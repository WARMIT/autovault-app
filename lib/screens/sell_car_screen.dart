import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/car.dart';
import '../models/seller.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';

class SellCarScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const SellCarScreen({Key? key, required this.onNavigateTab}) : super(key: key);

  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  int _listingCategoryIndex = 0; // 0 = House, 1 = Car
  final _formKey = GlobalKey<FormState>();

  // House fields
  ListingType _listingType = ListingType.forSale;
  PropertyType _propertyType = PropertyType.villa;
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _subCityController = TextEditingController(text: 'Bole Atlas');
  final _bedroomsController = TextEditingController(text: '4');
  final _bathroomsController = TextEditingController(text: '4');
  final _areaController = TextEditingController(text: '320');
  bool _hasWater = true;
  bool _hasGenerator = true;

  // Car fields
  final _makeController = TextEditingController(text: 'Toyota');
  final _modelController = TextEditingController(text: 'Land Cruiser');
  final _yearController = TextEditingController(text: '2023');
  final _mileageController = TextEditingController(text: '15000');
  String _transmission = 'Automatic';
  String _fuelType = 'Hybrid';

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _subCityController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;
    final store = CarStoreProvider.of(context);

    if (_listingCategoryIndex == 0) {
      // House
      final priceVal = double.tryParse(_priceController.text.replaceAll(',', '')) ?? 25000000;
      final newProp = Property(
        id: 'prop-user-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.isEmpty ? 'Luxury Residence' : _titleController.text,
        listingType: _listingType,
        propertyType: _propertyType,
        price: priceVal,
        subCity: _subCityController.text,
        wereda: 'Wereda 02',
        address: 'Bole Road, Addis Ababa',
        bedrooms: int.tryParse(_bedroomsController.text) ?? 3,
        bathrooms: int.tryParse(_bathroomsController.text) ?? 3,
        areaSqm: double.tryParse(_areaController.text) ?? 250,
        hasWater: _hasWater,
        hasGenerator: _hasGenerator,
        seller: const Seller(
          id: 'agent-user',
          name: 'My Broker Profile',
          type: 'Verified Independent Broker',
          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
          rating: 5.0,
          reviewCount: 1,
          phone: '+251 91 199 8877',
          email: 'myagent@allsell.et',
          location: 'Addis Ababa',
          responseTime: '< 5 mins',
          memberSinceYear: 2024,
          isVerified: true,
          tinNumber: '0099887766',
        ),
        images: const [
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=80',
        ],
        features: const ['24/7 Water Reservoir', 'Standby Generator', 'European Kitchen'],
        description: 'Newly listed verified property in Addis Ababa with full title deed clearance.',
      );

      store.addProperty(newProp);
      store.setActiveCategory(CategoryMode.houses);
    } else {
      // Car
      final priceVal = double.tryParse(_priceController.text.replaceAll(',', '')) ?? 6500000;
      final newCar = Car(
        id: 'car-user-${DateTime.now().millisecondsSinceEpoch}',
        title: '${_makeController.text} ${_modelController.text} ${_yearController.text}',
        brand: _makeController.text,
        model: _modelController.text,
        year: int.tryParse(_yearController.text) ?? 2023,
        price: priceVal,
        mileage: int.tryParse(_mileageController.text) ?? 10000,
        condition: 'Foreign Used',
        fuelType: _fuelType,
        transmission: _transmission,
        bodyType: 'SUV',
        exteriorColor: 'Obsidian Black',
        interiorColor: 'Black Leather',
        vin: 'ET9918237461928',
        horsepower: 240,
        acceleration0To60: 7.8,
        topSpeedMph: 125,
        rangeOrMpg: '14 km/L',
        engine: '2.5L 4-Cylinder',
        drivetrain: 'AWD',
        location: '${_subCityController.text}, Addis Ababa',
        seller: const Seller(
          id: 'agent-user',
          name: 'My Auto Showroom',
          type: 'Authorized Auto Dealer',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
          rating: 5.0,
          reviewCount: 1,
          phone: '+251 91 199 8877',
          email: 'autosales@allsell.et',
          location: 'Addis Ababa',
          responseTime: '< 5 mins',
          memberSinceYear: 2024,
          isVerified: true,
          tinNumber: '0099887766',
        ),
        images: const [
          'https://images.unsplash.com/photo-1568844293986-8d0400bd4745?auto=format&fit=crop&w=1200&q=80',
        ],
        features: const ['Libre Available', 'Customs Duty Cleared', 'Touchscreen'],
        description: 'Verified automobile with valid customs clearance documents.',
      );

      store.addCar(newCar);
      store.setActiveCategory(CategoryMode.cars);
    }

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.verifiedGreen,
        content: Text('Listing submitted to Moderator Queue with Verified status!'),
      ),
    );

    widget.onNavigateTab(0); // Return to home explore feed
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidianBlack : AppColors.cashmereBg,
      appBar: AppBar(
        title: const Text('Post New Listing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Dual Choice: [ Post a House ] | [ Post a Car ]
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.charcoalCard : AppColors.cashmereElevated,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _listingCategoryIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _listingCategoryIndex == 0
                                ? (isDark ? AppColors.charcoalDark : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: _listingCategoryIndex == 0
                                ? Border.all(color: AppColors.primaryAmber, width: 1.2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_work_rounded,
                                size: 18,
                                color: _listingCategoryIndex == 0 ? AppColors.primaryAmber : AppColors.textDarkMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'House / Property',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: _listingCategoryIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                                  color: _listingCategoryIndex == 0
                                      ? (isDark ? Colors.white : AppColors.textDarkPrimary)
                                      : AppColors.textDarkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _listingCategoryIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _listingCategoryIndex == 1
                                ? (isDark ? AppColors.charcoalDark : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: _listingCategoryIndex == 1
                                ? Border.all(color: AppColors.primaryAmber, width: 1.2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car_filled_rounded,
                                size: 18,
                                color: _listingCategoryIndex == 1 ? AppColors.primaryAmber : AppColors.textDarkMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Car / Vehicle',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: _listingCategoryIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                                  color: _listingCategoryIndex == 1
                                      ? (isDark ? Colors.white : AppColors.textDarkPrimary)
                                      : AppColors.textDarkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Sections
              if (_listingCategoryIndex == 0) ...[
                // HOUSE FORM
                const Text('Property Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Listing Title',
                    hintText: 'e.g. Modern Bole Villa with Swimming Pool',
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ListingType>(
                        value: _listingType,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: const [
                          DropdownMenuItem(value: ListingType.forSale, child: Text('For Sale')),
                          DropdownMenuItem(value: ListingType.forRent, child: Text('For Rent')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _listingType = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<PropertyType>(
                        value: _propertyType,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: const [
                          DropdownMenuItem(value: PropertyType.villa, child: Text('Villa')),
                          DropdownMenuItem(value: PropertyType.apartment, child: Text('Apartment')),
                          DropdownMenuItem(value: PropertyType.condominium, child: Text('Condo')),
                          DropdownMenuItem(value: PropertyType.commercial, child: Text('Commercial')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _propertyType = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price in Ethiopian Birr (ETB)',
                    hintText: 'e.g. 18,500,000',
                    prefixText: 'ETB ',
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Price is required' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _subCityController,
                        decoration: const InputDecoration(labelText: 'Sub-City (e.g. Bole)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _areaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Area (m²)', suffixText: 'm²'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bedroomsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Bedrooms'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _bathroomsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Bathrooms'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('24/7 Water Reservoir Installed', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  value: _hasWater,
                  activeColor: AppColors.primaryAmber,
                  onChanged: (val) => setState(() => _hasWater = val),
                ),
                SwitchListTile(
                  title: const Text('Backup Power Generator Available', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  value: _hasGenerator,
                  activeColor: AppColors.primaryAmber,
                  onChanged: (val) => setState(() => _hasGenerator = val),
                ),
              ] else ...[
                // CAR FORM
                const Text('Vehicle Specifications', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _makeController,
                        decoration: const InputDecoration(labelText: 'Make (e.g. Toyota)'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _modelController,
                        decoration: const InputDecoration(labelText: 'Model (e.g. RAV4)'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Year'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _mileageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Mileage (km)', suffixText: 'km'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Asking Price in ETB',
                    hintText: 'e.g. 7,200,000',
                    prefixText: 'ETB ',
                  ),
                  validator: (v) => v!.isEmpty ? 'Price is required' : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _transmission,
                        decoration: const InputDecoration(labelText: 'Transmission'),
                        items: const [
                          DropdownMenuItem(value: 'Automatic', child: Text('Automatic')),
                          DropdownMenuItem(value: 'Manual', child: Text('Manual')),
                        ],
                        onChanged: (v) => setState(() => _transmission = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _fuelType,
                        decoration: const InputDecoration(labelText: 'Fuel'),
                        items: const [
                          DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
                          DropdownMenuItem(value: 'Gasoline', child: Text('Petrol')),
                          DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                          DropdownMenuItem(value: 'Electric', child: Text('Electric')),
                        ],
                        onChanged: (v) => setState(() => _fuelType = v!),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // KYC Trustmark notice
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryAmber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryAmber.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.primaryAmber, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your listing will be verified by moderators with your active TIN certificate before being promoted.',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryAmberDark, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAmber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Publish Verified Listing',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
