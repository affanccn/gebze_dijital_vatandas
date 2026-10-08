import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../models/chat_action.dart';
import '../engine/intent_engine.dart';
import '../presentation/widgets/bot82_state.dart';

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isProcessing;
  final bool showConfetti;

  const ChatbotState({
    required this.messages,
    this.isProcessing = false,
    this.showConfetti = false,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isProcessing,
    bool? showConfetti,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }
}

class ChatbotNotifier extends Notifier<ChatbotState> {
  final IntentEngine _engine = IntentEngine();

  @override
  ChatbotState build() {
    _engine.loadConfig();
    return ChatbotState(
      messages: [
        ChatMessage.bot(
          'Merhaba 👋\nSize nasıl yardımcı olabilirim?',
          action: const ChatAction(type: ChatActionType.suggest),
          suggestions: const [
            'Su Kesintileri',
            'Etkinlikler',
            'Belediyeye Ulaş',
            'Talep Bildir',
          ],
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Kullanıcı mesajını ekle
    final userMsg = ChatMessage.user(text);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isProcessing: true,
    );
    
    ref.read(bot82Provider.notifier).beginThinking();

    // Kısa bir bekleme efekti (Kullanıcı deneyimi için, anlık olsa bile bot düşünüyormuş gibi yapabiliriz)
    await Future.delayed(const Duration(milliseconds: 300));

    await _engine.loadConfig();
    final intent = _engine.matchIntent(text);
    
    ChatMessage botMsg;
    ChatAction action;
    if (intent.action == 'navigate' && intent.route != null) {
      action = ChatAction(type: ChatActionType.navigate, route: intent.route);
    } else if (intent.action == 'suggest') {
      action = ChatAction(type: ChatActionType.suggest, route: intent.route);
    } else if (intent.action == 'ask' || intent.action == 'request') {
      action = ChatAction(type: ChatActionType.suggest); // ask/request shows suggestions too
    } else {
      action = ChatAction(type: ChatActionType.answer);
    }

    botMsg = ChatMessage.bot(
      intent.response,
      action: action,
      suggestions: intent.suggestions,
    );

    state = state.copyWith(
      messages: [...state.messages, botMsg],
      isProcessing: false,
      showConfetti: intent.intentId == 'easter_egg_82',
    );
    
    ref.read(bot82Provider.notifier).endThinking();
  }
}

final chatbotProvider = NotifierProvider<ChatbotNotifier, ChatbotState>(() {
  return ChatbotNotifier();
});
