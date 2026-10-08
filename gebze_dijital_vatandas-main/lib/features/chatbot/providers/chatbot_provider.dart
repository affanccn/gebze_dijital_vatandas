import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../models/chat_action.dart';
import '../engine/intent_matcher.dart';

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isProcessing;

  const ChatbotState({
    required this.messages,
    this.isProcessing = false,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isProcessing,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class ChatbotNotifier extends Notifier<ChatbotState> {
  @override
  ChatbotState build() {
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

    // Kısa bir bekleme efekti (Kullanıcı deneyimi için, anlık olsa bile bot düşünüyormuş gibi yapabiliriz)
    await Future.delayed(const Duration(milliseconds: 300));

    final intent = IntentMatcher.match(text);
    
    ChatMessage botMsg;
    if (intent != null) {
      ChatAction action;
      if (intent.actionType == ChatActionType.navigate && intent.route != null) {
        action = ChatAction(type: ChatActionType.navigate, route: intent.route);
      } else if (intent.actionType == ChatActionType.suggest) {
        action = ChatAction(type: ChatActionType.suggest, route: intent.route);
      } else {
        action = ChatAction(type: ChatActionType.answer);
      }

      botMsg = ChatMessage.bot(
        intent.response,
        action: action,
        suggestions: intent.suggestions,
      );
    } else {
      botMsg = ChatMessage.bot(
        'Ben Gebze Dijital hizmetleri konusunda yardımcı olabilirim.\nÖrneğin:\n\n• Su kesintileri\n• Etkinlikler\n• Belediye iletişim\n• Vergi işlemleri\n• Talep ve şikayetler',
        action: const ChatAction(type: ChatActionType.none),
      );
    }

    state = state.copyWith(
      messages: [...state.messages, botMsg],
      isProcessing: false,
    );
  }
}

final chatbotProvider = NotifierProvider<ChatbotNotifier, ChatbotState>(() {
  return ChatbotNotifier();
});
