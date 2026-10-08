import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/chat_message.dart';
import '../../models/chat_action.dart';

class BotMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onSuggestionTap;

  const BotMessageWidget({
    super.key,
    required this.message,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, right: 40.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.smart_toy_rounded,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
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
              ),
            ],
          ),
          
          if (message.action?.type == ChatActionType.navigate && message.action?.route != null)
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go(message.action!.route!);
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
      ),
    );
  }
}
