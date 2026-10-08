import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/chatbot_provider.dart';
import '../models/chat_message.dart';
import 'widgets/chat_input.dart';
import 'widgets/user_message.dart';
import 'widgets/bot_message.dart';
import 'widgets/bot82_chat_avatar.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as dart_math;
import 'widgets/bot82_state.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  final bool isMini;
  const ChatbotScreen({super.key, this.isMini = false});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

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
    final bot82State = ref.watch(bot82Provider);

    // Scroll automatically when new messages arrive
    ref.listen(chatbotProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
      if (next.showConfetti && (previous == null || !previous.showConfetti)) {
        _confettiController.play();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/bot82_full.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text('Bot82', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: widget.isMini
            ? [
                IconButton(
                  icon: const Icon(Icons.open_in_full),
                  tooltip: 'Tam Ekran',
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal
                    context.push('/chatbot'); // Open full screen
                  },
                )
              ]
            : null,
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
                  return Bot82MessageRow(
                    isLatest: true,
                    thinking: true,
                    bubble: Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text('...'),
                      ),
                    ),
                  );
                }

                final message = chatState.messages[index];
                if (message.role == MessageRole.user) {
                  return UserMessageWidget(message: message);
                } else {
                  // Find if it's the last bot message
                  final isLastBot = index == chatState.messages.lastIndexWhere((m) => m.role == MessageRole.bot);
                  return Bot82MessageRow(
                    isLatest: isLastBot,
                    thinking: isLastBot && bot82State.mode == Bot82Mode.thinking,
                    bubble: BotMessageWidget(
                      message: message,
                      onSuggestionTap: (text) {
                        ref.read(chatbotProvider.notifier).sendMessage(text);
                      },
                      onNavigate: (route) {
                        if (widget.isMini) {
                          Navigator.of(context).pop();
                        }
                        context.push(route);
                      },
                    ),
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
      floatingActionButton: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          createParticlePath: drawStar,
        ),
      ),
    );
  }

  Path drawStar(Size size) {
    // Draws a star for confetti
    double degToRad(double deg) => deg * (3.14159265358979323846 / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * dart_math.cos(step),
          halfWidth + externalRadius * dart_math.sin(step));
      path.lineTo(halfWidth + internalRadius * dart_math.cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * dart_math.sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
