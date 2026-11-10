import 'seller.dart';

enum ListingType {
  forSale,
  forRent,
}

enum PropertyType {
  villa,
  apartment,
  condominium,
  commercial,
  townhouse,
}

class Property {
  final String id;
  final String title;
  final ListingType listingType;
  final PropertyType propertyType;
  final double price; // In ETB
  final String? rentalPeriod; // 'month', 'year'
  final String city; // Addis Ababa, Hawassa, etc.
  final String subCity; // Bole, Kirkos, Yeka, CMC, etc.
  final String wereda;
  final String address;
  final int bedrooms;
  final int bathrooms;
  final double areaSqm;
  final int floor;
  final int parkingSpots;
  final String furnishingStatus; // 'Fully Furnished', 'Unfurnished', 'Semi-Furnished'
  
  // Ethiopian Critical Utilities & Amenities
  final bool hasWater; // 24/7 Water Reservoir / Backup Tank
  final bool hasGenerator; // Backup Power Generator
  final bool hasElectricity; // 3-Phase Stable Power
  final bool hasInternet; // High-speed fiber WiFi
  final bool hasSecurity; // Gated 24/7 Guard
  final bool hasElevator;
  final bool hasBalcony;
  final bool hasGarden;

  final Seller seller;
  final List<String> images;
  final List<String> features;
  final String description;
  final bool isVerified;
  final bool isFeatured;
  final int viewsCount;

  const Property({
    required this.id,
    required this.title,
    required this.listingType,
    required this.propertyType,
    required this.price,
    this.rentalPeriod,
    this.city = 'Addis Ababa',
    required this.subCity,
    required this.wereda,
    required this.address,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqm,
    this.floor = 1,
    this.parkingSpots = 1,
    this.furnishingStatus = 'Unfurnished',
    this.hasWater = true,
    this.hasGenerator = true,
    this.hasElectricity = true,
    this.hasInternet = true,
    this.hasSecurity = true,
    this.hasElevator = false,
    this.hasBalcony = true,
    this.hasGarden = false,
    required this.seller,
    required this.images,
    required this.features,
    required this.description,
    this.isVerified = true,
    this.isFeatured = false,
    this.viewsCount = 342,
  });

  String get primaryImage => images.isNotEmpty
      ? images.first
      : 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80';

  String get formattedPrice {
    final formatted = price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    if (listingType == ListingType.forRent) {
      return 'ETB $formatted / ${rentalPeriod ?? 'mo'}';
    }
    return 'ETB $formatted';
  }

  String get typeLabel {
    switch (propertyType) {
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.condominium:
        return 'Condo';
      case PropertyType.commercial:
        return 'Commercial';
      case PropertyType.townhouse:
        return 'Townhouse';
    }
  }

  String get specsSummary => '$bedrooms Beds · $bathrooms Baths · ${areaSqm.toInt()} m²';

  String get locationSummary => '$subCity, $city';
}

