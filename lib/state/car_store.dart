import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/brand.dart';
import '../models/seller.dart';
import '../models/chat_message.dart';
import '../models/test_drive_booking.dart';
import '../data/mock_cars.dart';

class CarStore extends ChangeNotifier {
  List<Car> _cars = List.from(MockData.initialCars);
  final Set<String> _favoriteIds = {'car-1', 'car-2'};
  final List<Car> _compareList = [];

  // Filter States
  String _selectedCategory = 'All';
  String _selectedBrand = 'All Makes';
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(20000, 350000);
  int _minYear = 2020;
  String? _selectedFuelType;
  String? _selectedTransmission;
  String _sortBy = 'Recommended';

  // App Theme State
  bool _isDarkMode = true;

  // Bookings and Messages
  final List<TestDriveBooking> _bookings = [
    TestDriveBooking(
      id: 'b1',
      carId: 'car-1',
      carTitle: 'Porsche 911 GT3 RS (992)',
      carImage: 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80',
      date: 'Tomorrow, Nov 3',
      timeSlot: '2:30 PM',
      locationType: 'Showroom Visit',
      contactName: 'Current User',
      contactPhone: '+1 (555) 912-3847',
      status: 'Confirmed',
    ),
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      carId: 'car-1',
      senderId: 's1',
      senderName: 'Apex Heritage Exotics',
      message: 'Hello! Thank you for your interest in the 2024 Porsche 911 GT3 RS. How can we assist you today?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isFromMe: false,
    ),
    ChatMessage(
      id: 'm2',
      carId: 'car-1',
      senderId: 'user',
      senderName: 'You',
      message: 'Hi! Is the car protected with full Paint Protection Film?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isFromMe: true,
    ),
    ChatMessage(
      id: 'm3',
      carId: 'car-1',
      senderId: 's1',
      senderName: 'Apex Heritage Exotics',
      message: 'Yes, full SunTek PPF with ceramic top-coat installed by factory certified detailers prior to delivery. Zero stone chips.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isFromMe: false,
    ),
  ];

  // Getters
  List<Car> get allCars => _cars;
  Set<String> get favoriteIds => _favoriteIds;
  List<Car> get compareList => _compareList;
  String get selectedCategory => _selectedCategory;
  String get selectedBrand => _selectedBrand;
  String get searchQuery => _searchQuery;
  RangeValues get priceRange => _priceRange;
  int get minYear => _minYear;
  String? get selectedFuelType => _selectedFuelType;
  String? get selectedTransmission => _selectedTransmission;
  String get sortBy => _sortBy;
  bool get isDarkMode => _isDarkMode;
  List<TestDriveBooking> get bookings => _bookings;
  List<ChatMessage> get messages => _messages;

  List<Car> get favoriteCars => _cars.where((car) => _favoriteIds.contains(car.id)).toList();

  List<Car> get userListedCars => _cars.where((car) => car.isUserListed).toList();

  List<Car> get featuredCars => _cars.where((car) => car.isFeatured).toList();

  List<Car> get dealCars => _cars.where((car) => car.isDeal).toList();

  List<Car> get electricCars => _cars.where((car) => car.fuelType == 'Electric').toList();

  List<Car> get filteredCars {
    List<Car> list = _cars.where((car) {
      // Category filter
      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Electric' && car.fuelType != 'Electric') return false;
        if (_selectedCategory != 'Electric' && car.bodyType.toLowerCase() != _selectedCategory.toLowerCase()) {
          return false;
        }
      }

      // Brand filter
      if (_selectedBrand != 'All Makes' && _selectedBrand.isNotEmpty) {
        if (!car.brand.toLowerCase().contains(_selectedBrand.toLowerCase())) return false;
      }

      // Search query filter
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = car.title.toLowerCase().contains(q);
        final matchesBrand = car.brand.toLowerCase().contains(q);
        final matchesModel = car.model.toLowerCase().contains(q);
        final matchesBody = car.bodyType.toLowerCase().contains(q);
        final matchesLocation = car.location.toLowerCase().contains(q);
        if (!matchesTitle && !matchesBrand && !matchesModel && !matchesBody && !matchesLocation) {
          return false;
        }
      }

      // Price filter
      if (car.price < _priceRange.start || car.price > _priceRange.end) {
        return false;
      }

      // Year filter
      if (car.year < _minYear) {
        return false;
      }

      // Fuel type filter
      if (_selectedFuelType != null && _selectedFuelType != 'All' && car.fuelType != _selectedFuelType) {
        return false;
      }

      // Transmission filter
      if (_selectedTransmission != null && _selectedTransmission != 'All' && car.transmission != _selectedTransmission) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Year: Newest':
        list.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Mileage: Lowest':
        list.sort((a, b) => a.mileage.compareTo(b.mileage));
        break;
      case 'Recommended':
      default:
        list.sort((a, b) {
          if (a.isFeatured && !b.isFeatured) return -1;
          if (!a.isFeatured && b.isFeatured) return 1;
          return b.rating.compareTo(a.rating);
        });
        break;
    }

    return list;
  }

  bool isFavorite(String carId) => _favoriteIds.contains(carId);

  void toggleFavorite(String carId) {
    if (_favoriteIds.contains(carId)) {
      _favoriteIds.remove(carId);
    } else {
      _favoriteIds.add(carId);
    }
    notifyListeners();
  }

  void toggleCompare(Car car) {
    final index = _compareList.indexWhere((c) => c.id == car.id);
    if (index >= 0) {
      _compareList.removeAt(index);
    } else {
      if (_compareList.length >= 3) {
        _compareList.removeAt(0); // keep at most 3
      }
      _compareList.add(car);
    }
    notifyListeners();
  }

  bool isInCompare(String carId) => _compareList.any((c) => c.id == carId);

  void clearCompare() {
    _compareList.clear();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setBrand(String brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  void setMinYear(int year) {
    _minYear = year;
    notifyListeners();
  }

  void setFuelType(String? fuelType) {
    _selectedFuelType = fuelType;
    notifyListeners();
  }

  void setTransmission(String? transmission) {
    _selectedTransmission = transmission;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _selectedBrand = 'All Makes';
    _searchQuery = '';
    _priceRange = const RangeValues(20000, 350000);
    _minYear = 2020;
    _selectedFuelType = null;
    _selectedTransmission = null;
    _sortBy = 'Recommended';
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void addCar(Car car) {
    _cars.insert(0, car);
    notifyListeners();
  }

  void bookTestDrive({
    required Car car,
    required String date,
    required String timeSlot,
    required String locationType,
    required String name,
    required String phone,
  }) {
    final booking = TestDriveBooking(
      id: 'b-${DateTime.now().millisecondsSinceEpoch}',
      carId: car.id,
      carTitle: car.title,
      carImage: car.primaryImage,
      date: date,
      timeSlot: timeSlot,
      locationType: locationType,
      contactName: name,
      contactPhone: phone,
      status: 'Confirmed',
    );
    _bookings.insert(0, booking);

    // Also add an automated confirmation message
    _messages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        carId: car.id,
        senderId: car.seller.id,
        senderName: car.seller.name,
        message: 'Your test drive for "${car.title}" on $date at $timeSlot has been confirmed ($locationType). Our team will prepare the vehicle for you.',
        timestamp: DateTime.now(),
        isFromMe: false,
      ),
    );

    notifyListeners();
  }

  void makeOffer({
    required Car car,
    required double offerAmount,
    String? note,
  }) {
    final msg = ChatMessage(
      id: 'offer-${DateTime.now().millisecondsSinceEpoch}',
      carId: car.id,
      senderId: 'user',
      senderName: 'You',
      message: note != null && note.isNotEmpty ? note : 'Official Offer Submitted: \$${offerAmount.toInt()}',
      timestamp: DateTime.now(),
      isFromMe: true,
      offerAmount: offerAmount,
      isOffer: true,
      status: 'sent',
    );
    _messages.add(msg);

    // Add seller response after a moment
    Future.delayed(const Duration(milliseconds: 600), () {
      _messages.add(
        ChatMessage(
          id: 'offer-resp-${DateTime.now().millisecondsSinceEpoch}',
          carId: car.id,
          senderId: car.seller.id,
          senderName: car.seller.name,
          message: 'Thank you for your offer of \$${offerAmount.toInt()}! We are reviewing the terms and will follow up with inspection documents shortly.',
          timestamp: DateTime.now(),
          isFromMe: false,
        ),
      );
      notifyListeners();
    });

    notifyListeners();
  }

  void sendMessage({
    required String carId,
    required String message,
  }) {
    _messages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        carId: carId,
        senderId: 'user',
        senderName: 'You',
        message: message,
        timestamp: DateTime.now(),
        isFromMe: true,
      ),
    );
    notifyListeners();
  }
}

class CarStoreProvider extends InheritedNotifier<CarStore> {
  const CarStoreProvider({
    Key? key,
    required CarStore store,
    required Widget child,
  }) : super(key: key, notifier: store, child: child);

  static CarStore of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CarStoreProvider>();
    assert(provider != null, 'No CarStoreProvider found in context');
    return provider!.notifier!;
  }
}
