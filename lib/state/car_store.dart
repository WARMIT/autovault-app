import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/property.dart';
import '../models/brand.dart';
import '../models/seller.dart';
import '../models/chat_message.dart';
import '../models/test_drive_booking.dart';
import '../data/mock_cars.dart';
import '../data/mock_properties.dart';

enum CategoryMode { houses, cars }
enum AppUserRole { customer, agent, auditor }

class CarStore extends ChangeNotifier {
  // --- Category Switcher ---
  CategoryMode _activeCategory = CategoryMode.houses;
  CategoryMode get activeCategory => _activeCategory;

  void setActiveCategory(CategoryMode mode) {
    if (_activeCategory != mode) {
      _activeCategory = mode;
      notifyListeners();
    }
  }

  // --- Active Role (Customer / Agent / Auditor) ---
  AppUserRole _activeRole = AppUserRole.customer;
  AppUserRole get activeRole => _activeRole;

  void setActiveRole(AppUserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  // --- Location State (Addis Ababa & Sub-cities) ---
  String _selectedCity = 'Addis Ababa';
  String _selectedSubCity = 'All Sub-cities';

  String get selectedCity => _selectedCity;
  String get selectedSubCity => _selectedSubCity;

  final List<String> availableSubCities = const [
    'All Sub-cities',
    'Bole',
    'Bole Atlas',
    'CMC',
    'Kazanchis',
    'Sarbet (Old Airport)',
    'Kirkos',
    'Yeka',
    'Meganagna',
    'Gerji',
    'Nifas Silk',
    'Lemi Kura',
    'Hawassa (Region)',
    'Bahir Dar (Region)',
  ];

  void setSelectedSubCity(String subCity) {
    _selectedSubCity = subCity;
    notifyListeners();
  }

  // --- Search & Filters ---
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Property Filters
  ListingType? _propertyListingTypeFilter;
  ListingType? get propertyListingTypeFilter => _propertyListingTypeFilter;

  void setPropertyListingTypeFilter(ListingType? type) {
    _propertyListingTypeFilter = type;
    notifyListeners();
  }

  // Car Filters
  String _selectedBrand = 'All Makes';
  String get selectedBrand => _selectedBrand;
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void setSelectedBrand(String brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // --- Data Collections ---
  final List<Property> _properties = List.from(MockProperties.initialProperties);
  final List<Car> _cars = List.from(MockData.initialCars);

  List<Property> get allProperties => _properties;
  List<Car> get allCars => _cars;

  // Favorites
  final Set<String> _favoriteIds = {'prop-1', 'car-1'};
  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<Property> get favoriteProperties =>
      _properties.where((p) => _favoriteIds.contains(p.id)).toList();

  List<Car> get favoriteCars =>
      _cars.where((c) => _favoriteIds.contains(c.id)).toList();

  // --- Contact Reveal Paywall (Telebirr / CBE Birr) ---
  final Set<String> _unlockedContactIds = {'prop-2'};
  Set<String> get unlockedContactIds => _unlockedContactIds;

  bool isContactUnlocked(String id) => _unlockedContactIds.contains(id);

  void unlockContact(String id) {
    _unlockedContactIds.add(id);
    notifyListeners();
  }

  // --- Filtered Feeds ---
  List<Property> get filteredProperties {
    return _properties.where((p) {
      if (_selectedSubCity != 'All Sub-cities' &&
          !p.subCity.toLowerCase().contains(_selectedSubCity.toLowerCase())) {
        return false;
      }
      if (_propertyListingTypeFilter != null &&
          p.listingType != _propertyListingTypeFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = p.title.toLowerCase().contains(query);
        final matchLocation = p.subCity.toLowerCase().contains(query);
        final matchType = p.typeLabel.toLowerCase().contains(query);
        if (!matchTitle && !matchLocation && !matchType) return false;
      }
      return true;
    }).toList();
  }

  List<Car> get filteredCars {
    return _cars.where((c) {
      if (_selectedSubCity != 'All Sub-cities' &&
          !c.location.toLowerCase().contains(_selectedSubCity.toLowerCase())) {
        return false;
      }
      if (_selectedBrand != 'All Makes' && c.brand != _selectedBrand) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = c.title.toLowerCase().contains(query);
        final matchBrand = c.brand.toLowerCase().contains(query);
        final matchModel = c.model.toLowerCase().contains(query);
        if (!matchTitle && !matchBrand && !matchModel) return false;
      }
      return true;
    }).toList();
  }

  // Featured
  List<Property> get featuredProperties =>
      _properties.where((p) => p.isFeatured).toList();

  List<Car> get featuredCars => _cars.where((c) => c.isFeatured).toList();

  // --- Agent & User Operations ---
  void addProperty(Property property) {
    _properties.insert(0, property);
    notifyListeners();
  }

  void addCar(Car car) {
    _cars.insert(0, car);
    notifyListeners();
  }

  // --- Theme Mode ---
  bool _isDarkMode = false; // Default to Light warm cashmere as requested
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // --- Chat & Booking compatibility ---
  final List<TestDriveBooking> _bookings = [];
  List<TestDriveBooking> get bookings => _bookings;

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      carId: 'prop-1',
      senderId: 'agent-1',
      senderName: 'Dawit Mengistu (Verified Broker)',
      message:
          'Selam! Thank you for inquiring about the Bole Atlas Luxury Villa. Sened (Title Deed) is verified and ready for inspection.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isFromMe: false,
    ),
  ];
  List<ChatMessage> get messages => _messages;

  void addMessage(ChatMessage msg) {
    _messages.add(msg);
    notifyListeners();
  }

  // Compare List
  final List<Car> _compareList = [];
  List<Car> get compareList => _compareList;

  bool isInCompare(String carId) => _compareList.any((c) => c.id == carId);

  void toggleCompare(Car car) {
    if (_compareList.any((c) => c.id == car.id)) {
      _compareList.removeWhere((c) => c.id == car.id);
    } else {
      if (_compareList.length < 3) {
        _compareList.add(car);
      }
    }
    notifyListeners();
  }

  void clearCompare() {
    _compareList.clear();
    notifyListeners();
  }

  // --- Search & Filter Screen Helpers ---
  RangeValues _priceRange = const RangeValues(500000, 35000000);
  RangeValues get priceRange => _priceRange;
  void setPriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  String? _selectedFuelType;
  String? get selectedFuelType => _selectedFuelType;
  void setFuelType(String? fuel) {
    _selectedFuelType = fuel;
    notifyListeners();
  }

  String? _selectedTransmission;
  String? get selectedTransmission => _selectedTransmission;
  void setTransmission(String? trans) {
    _selectedTransmission = trans;
    notifyListeners();
  }

  String _sortBy = 'Recommended';
  String get sortBy => _sortBy;
  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedBrand = 'All Makes';
    _selectedCategory = 'All';
    _selectedSubCity = 'All Sub-cities';
    _propertyListingTypeFilter = null;
    _priceRange = const RangeValues(500000, 35000000);
    _selectedFuelType = null;
    _selectedTransmission = null;
    _sortBy = 'Recommended';
    notifyListeners();
  }

  // --- Chat & Booking Support ---
  void sendMessage({required String carId, required String message}) {
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

  void addAutomatedReply({required String carId, required String message, required String senderName}) {
    _messages.add(
      ChatMessage(
        id: 'reply-${DateTime.now().millisecondsSinceEpoch}',
        carId: carId,
        senderId: 'agent',
        senderName: senderName,
        message: message,
        timestamp: DateTime.now(),
        isFromMe: false,
      ),
    );
    notifyListeners();
  }

  void makeOffer({required String carId, required double offerAmount, required String note}) {
    notifyListeners();
  }

  void bookTestDrive(TestDriveBooking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  // --- Auditor & Government Platform Stats ---
  int get auditorRegisteredAgents => 1250;
  int get auditorActiveAgents => 980;
  int get auditorTotalTransactions => 8540;
  double get auditorTotalSalesValueETB => 450200000.0;
  double get auditorTotalRentalValueETB => 82400000.0;
  double get auditorTotalBrokerCommissionETB => 13506000.0;
  double get auditorEstimatedTaxWithheldETB => 2701200.0; // 20% estimated ERA withholding
}

class CarStoreProvider extends InheritedNotifier<CarStore> {
  const CarStoreProvider({
    Key? key,
    required CarStore store,
    required Widget child,
  }) : super(key: key, notifier: store, child: child);

  static CarStore of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CarStoreProvider>();
    assert(provider != null, 'No CarStoreProvider found in context');
    return provider!.notifier!;
  }
}
