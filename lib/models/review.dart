class Review {
  final String id;
  final String authorName;
  final String authorAvatar;
  final double rating;
  final String comment;
  final String date;
  final String carModel;

  const Review({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    required this.carModel,
  });
}
