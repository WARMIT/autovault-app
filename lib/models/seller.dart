class Seller {
  final String id;
  final String name;
  final String type; // 'Verified Dealer', 'Private Collector', 'Certified Showroom'
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final String phone;
  final String email;
  final String location;
  final String responseTime;
  final int memberSinceYear;
  final bool isVerified;

  const Seller({
    required this.id,
    required this.name,
    required this.type,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    required this.email,
    required this.location,
    required this.responseTime,
    required this.memberSinceYear,
    this.isVerified = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'phone': phone,
      'email': email,
      'location': location,
      'responseTime': responseTime,
      'memberSinceYear': memberSinceYear,
      'isVerified': isVerified,
    };
  }

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Private Seller',
      avatarUrl: map['avatarUrl'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: map['reviewCount'] ?? 0,
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      responseTime: map['responseTime'] ?? '< 1 hour',
      memberSinceYear: map['memberSinceYear'] ?? 2022,
      isVerified: map['isVerified'] ?? true,
    );
  }
}
