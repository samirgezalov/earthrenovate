import 'package:flutter/material.dart';
import '../../domain/models/chat_message.dart';
import '../../core/theme/app_theme.dart';

class ChatOverlay extends StatelessWidget {
  final List<ChatMessage> messages;
  final Function(String) onSendMessage;

  const ChatOverlay({
    super.key,
    required this.messages,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Container(
      width: 350,
      margin: const EdgeInsets.all(16),
      decoration: AppTheme.glassmorphismDecoration.copyWith(
        color: Colors.black.withOpacity(0.4),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Secure Channel Chat',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment:
                        msg.isLocal ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.senderName,
                        style: TextStyle(
                            fontSize: 10,
                            color: msg.isLocal ? AppTheme.accent : Colors.blueAccent),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: msg.isLocal
                              ? AppTheme.accent.withOpacity(0.2)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.text,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (val) {
                      onSendMessage(val);
                      controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.accent),
                  onPressed: () {
                    onSendMessage(controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
