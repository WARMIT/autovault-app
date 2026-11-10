import 'dart:math';
import 'seller.dart';

class Car {
  final String id;
  final String title;
  final String brand;
  final String model;
  final int year;
  final double price;
  final double? originalPrice;
  final int mileage;
  final String condition; // 'Pristine', 'Certified Pre-Owned', 'Excellent', 'Good'
  final String fuelType; // 'Electric', 'Hybrid', 'Gasoline'
  final String transmission; // 'Automatic', 'Manual', 'Dual-Clutch'
  final String bodyType; // 'Supercar', 'Coupe', 'Sedan', 'SUV', 'Convertible'
  final String exteriorColor;
  final String interiorColor;
  final String vin;
  final int horsepower;
  final double acceleration0To60; // seconds
  final int topSpeedMph;
  final String rangeOrMpg; // '405 mi range' or '22 MPG'
  final String engine;
  final String drivetrain; // 'AWD', 'RWD'
  final String location;
  final Seller seller;
  final List<String> images;
  final List<String> features;
  final bool isFeatured;
  final bool isDeal;
  final double rating;
  final int reviewCount;
  final bool isUserListed;
  final String description;

  const Car({
    required this.id,
    required this.title,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    this.originalPrice,
    required this.mileage,
    required this.condition,
    required this.fuelType,
    required this.transmission,
    required this.bodyType,
    required this.exteriorColor,
    required this.interiorColor,
    required this.vin,
    required this.horsepower,
    required this.acceleration0To60,
    required this.topSpeedMph,
    required this.rangeOrMpg,
    required this.engine,
    required this.drivetrain,
    required this.location,
    required this.seller,
    required this.images,
    required this.features,
    this.isFeatured = false,
    this.isDeal = false,
    this.rating = 4.9,
    this.reviewCount = 18,
    this.isUserListed = false,
    required this.description,
  });

  String get primaryImage => images.isNotEmpty
      ? images.first
      : 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80';

  String get formattedPrice {
    return 'ETB ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get formattedOriginalPrice {
    if (originalPrice == null) return '';
    return 'ETB ${originalPrice!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get formattedMileage {
    return '${mileage.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} km';
  }

  String get specsSummary => '$year · $transmission · $fuelType · $formattedMileage';

  double calculateMonthlyEmi({double downPaymentPercent = 0.20, int months = 48, double apr = 14.5}) {
    final loanAmount = price * (1.0 - downPaymentPercent);
    final monthlyRate = (apr / 100) / 12;
    if (monthlyRate == 0) return loanAmount / months;
    final emi = (loanAmount * monthlyRate * pow(1 + monthlyRate, months)) / (pow(1 + monthlyRate, months) - 1);
    return emi;
  }

  String formattedMonthlyEmi({double downPaymentPercent = 0.20, int months = 48, double apr = 14.5}) {
    final emi = calculateMonthlyEmi(downPaymentPercent: downPaymentPercent, months: months, apr: apr);
    return 'ETB ${emi.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/mo';
  }

  Car copyWith({
    String? id,
    String? title,
    String? brand,
    String? model,
    int? year,
    double? price,
    double? originalPrice,
    int? mileage,
    String? condition,
    String? fuelType,
    String? transmission,
    String? bodyType,
    String? exteriorColor,
    String? interiorColor,
    String? vin,
    int? horsepower,
    double? acceleration0To60,
    int? topSpeedMph,
    String? rangeOrMpg,
    String? engine,
    String? drivetrain,
    String? location,
    Seller? seller,
    List<String>? images,
    List<String>? features,
    bool? isFeatured,
    bool? isDeal,
    double? rating,
    int? reviewCount,
    bool? isUserListed,
    String? description,
  }) {
    return Car(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      mileage: mileage ?? this.mileage,
      condition: condition ?? this.condition,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      bodyType: bodyType ?? this.bodyType,
      exteriorColor: exteriorColor ?? this.exteriorColor,
      interiorColor: interiorColor ?? this.interiorColor,
      vin: vin ?? this.vin,
      horsepower: horsepower ?? this.horsepower,
      acceleration0To60: acceleration0To60 ?? this.acceleration0To60,
      topSpeedMph: topSpeedMph ?? this.topSpeedMph,
      rangeOrMpg: rangeOrMpg ?? this.rangeOrMpg,
      engine: engine ?? this.engine,
      drivetrain: drivetrain ?? this.drivetrain,
      location: location ?? this.location,
      seller: seller ?? this.seller,
      images: images ?? this.images,
      features: features ?? this.features,
      isFeatured: isFeatured ?? this.isFeatured,
      isDeal: isDeal ?? this.isDeal,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isUserListed: isUserListed ?? this.isUserListed,
      description: description ?? this.description,
    );
  }
}
