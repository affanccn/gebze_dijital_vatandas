import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chatbot_provider.dart';
import '../models/chat_message.dart';
import 'widgets/chat_input.dart';
import 'widgets/user_message.dart';
import 'widgets/bot_message.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatbotProvider);

    // Scroll automatically when new messages arrive
    ref.listen(chatbotProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebze Dijital Asistan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: chatState.messages.length + (chatState.isProcessing ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chatState.messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final message = chatState.messages[index];
                if (message.role == MessageRole.user) {
                  return UserMessageWidget(message: message);
                } else {
                  return BotMessageWidget(
                    message: message,
                    onSuggestionTap: (text) {
                      ref.read(chatbotProvider.notifier).sendMessage(text);
                    },
                  );
                }
              },
            ),
          ),
          ChatInput(
            onSend: (text) {
              ref.read(chatbotProvider.notifier).sendMessage(text);
            },
          ),
        ],
      ),
    );
  }
}
