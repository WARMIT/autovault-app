class ChatMessage {
  final String id;
  final String carId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromMe;
  final double? offerAmount;
  final bool isOffer;
  final String status; // 'sent', 'accepted', 'countered', 'declined'

  ChatMessage({
    required this.id,
    required this.carId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isFromMe,
    this.offerAmount,
    this.isOffer = false,
    this.status = 'sent',
  });
}
