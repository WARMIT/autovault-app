class TestDriveBooking {
  final String id;
  final String carId;
  final String carTitle;
  final String carImage;
  final String date;
  final String timeSlot;
  final String locationType; // 'Showroom Visit' or 'Concierge Delivery'
  final String contactName;
  final String contactPhone;
  final String status; // 'Confirmed', 'Pending', 'Completed'
  final DateTime createdAt;

  TestDriveBooking({
    required this.id,
    required this.carId,
    required this.carTitle,
    required this.carImage,
    required this.date,
    required this.timeSlot,
    required this.locationType,
    required this.contactName,
    required this.contactPhone,
    this.status = 'Confirmed',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
