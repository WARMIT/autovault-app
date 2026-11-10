class Seller {
  final String id;
  final String name;
  final String type; // 'Verified Broker', 'Certified Real Estate Agency', 'Authorized Auto Dealer'
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final String phone;
  final String email;
  final String location;
  final String responseTime;
  final int memberSinceYear;
  final bool isVerified;
  final String tinNumber; // Ethiopian TIN (e.g., '0049281729')
  final String licenseNumber; // Ministry of Trade License

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
    this.tinNumber = '0049281729',
    this.licenseNumber = 'ET-AA-2024-9182',
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
      'tinNumber': tinNumber,
      'licenseNumber': licenseNumber,
    };
  }

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Verified Broker',
      avatarUrl: map['avatarUrl'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: map['reviewCount'] ?? 0,
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      responseTime: map['responseTime'] ?? '< 15 mins',
      memberSinceYear: map['memberSinceYear'] ?? 2023,
      isVerified: map['isVerified'] ?? true,
      tinNumber: map['tinNumber'] ?? '0049281729',
      licenseNumber: map['licenseNumber'] ?? 'ET-AA-2024-9182',
    );
  }
}
