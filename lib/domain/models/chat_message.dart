class ChatMessage {
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isLocal;

  ChatMessage({
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isLocal = false,
  });
}
