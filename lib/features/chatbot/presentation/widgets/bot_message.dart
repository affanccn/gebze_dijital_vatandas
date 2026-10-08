import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_message.dart';
import '../../models/chat_action.dart';


class BotMessageWidget extends ConsumerWidget {
  final ChatMessage message;
  final Function(String) onSuggestionTap;
  final Function(String)? onNavigate;

  const BotMessageWidget({
    super.key,
    required this.message,
    required this.onSuggestionTap,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
          
          if (message.action?.type == ChatActionType.navigate && message.action?.route != null)
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (onNavigate != null) {
                    onNavigate!(message.action!.route!);
                  } else {
                    context.push(message.action!.route!);
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Sayfaya Git'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          if (message.suggestions != null && message.suggestions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: message.suggestions!.map((suggestion) {
                  return ActionChip(
                    label: Text(suggestion),
                    onPressed: () => onSuggestionTap(suggestion),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
    );
  }
}
