import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/seller.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_image.dart';
import 'car_details_screen.dart';

class SellCarScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const SellCarScreen({Key? key, required this.onNavigateTab}) : super(key: key);

  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Curated high quality automotive stock image presets for quick selection
  final List<Map<String, String>> _stockImagePresets = [
    {
      'name': 'Porsche 911 / Sports Coupe',
      'url': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'name': 'Tesla / Electric Sedan',
      'url': 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'name': 'Mercedes-AMG / Luxury GT',
      'url': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'name': 'BMW M Performance',
      'url': 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'name': 'Audi RS Sport',
      'url': 'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'name': 'Lamborghini / Exotic',
      'url': 'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?auto=format&fit=crop&w=1200&q=80',
    },
    {
      'name': 'Range Rover / Luxury SUV',
      'url': 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=1200&q=80',
    },
  ];

  late String _selectedImageUrl;
  final TextEditingController _customImageUrlController = TextEditingController();

  String _selectedBrand = 'Porsche';
  final TextEditingController _modelController = TextEditingController(text: 'Cayman GT4 RS');
  int _selectedYear = 2024;
  final TextEditingController _priceController = TextEditingController(text: '168500');
  final TextEditingController _mileageController = TextEditingController(text: '2400');
  final TextEditingController _hpController = TextEditingController(text: '493');
  final TextEditingController _accelerationController = TextEditingController(text: '3.2');
  final TextEditingController _topSpeedController = TextEditingController(text: '196');
  final TextEditingController _engineController = TextEditingController(text: '4.0L Naturally Aspirated Boxer-6');
  final TextEditingController _locationController = TextEditingController(text: 'Newport Beach, CA');
  final TextEditingController _vinController = TextEditingController(text: 'WP0AF2A89NS291034');
  final TextEditingController _descriptionController = TextEditingController(
    text: 'Single-owner, pristine condition with ceramic coating. Full titanium exhaust and carbon package. Never tracked.',
  );

  String _condition = 'Pristine';
  String _fuelType = 'Gasoline';
  String _transmission = 'Dual-Clutch';
  String _bodyType = 'Coupe';
  String _exteriorColor = 'Arctic Grey';
  String _interiorColor = 'Black Alcantara with Guards Red';
  bool _isNegotiable = true;

  final Set<String> _selectedFeatures = {
    'Carbon Ceramic Brakes',
    'Chrono Package',
    'Sport Exhaust',
    'Carbon Bucket Seats',
    'Apple CarPlay',
  };

  final List<String> _availableFeatures = [
    'Carbon Ceramic Brakes',
    'Chrono Package',
    'Sport Exhaust',
    'Carbon Bucket Seats',
    'Apple CarPlay',
    'Burmester Sound',
    'Front Axle Lift',
    'Full PPF Film',
    'Panoramic Roof',
    'Head-Up Display',
    'Adaptive Cruise',
  ];

  @override
  void initState() {
    super.initState();
    _selectedImageUrl = _stockImagePresets[0]['url']!;
  }

  @override
  void dispose() {
    _customImageUrlController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _hpController.dispose();
    _accelerationController.dispose();
    _topSpeedController.dispose();
    _engineController.dispose();
    _locationController.dispose();
    _vinController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _estimateValuation() {
    final price = double.tryParse(_priceController.text) ?? 150000;
    final lower = (price * 0.94).toInt();
    final upper = (price * 1.05).toInt();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: AppColors.accentCyan),
            SizedBox(width: 10),
            Text('Smart Market Valuation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on verified sales of $_selectedYear $_selectedBrand ${_modelController.text} with ${_mileageController.text} miles:',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('RECOMMENDED LISTING RANGE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                  const SizedBox(height: 4),
                  Text('\$$lower - \$$upper',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your vehicle is in high demand. Setting price within this range typically receives offers in under 4 days.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Apply Valuation'),
          ),
        ],
      ),
    );
  }

  void _publishCar() {
    if (!_formKey.currentState!.validate()) return;

    final store = CarStoreProvider.of(context);
    final price = double.tryParse(_priceController.text) ?? 150000;
    final mileage = int.tryParse(_mileageController.text) ?? 2000;
    final hp = int.tryParse(_hpController.text) ?? 450;
    final accel = double.tryParse(_accelerationController.text) ?? 3.4;
    final topSpeed = int.tryParse(_topSpeedController.text) ?? 185;

    final newCar = Car(
      id: 'user-car-${DateTime.now().millisecondsSinceEpoch}',
      title: '$_selectedYear $_selectedBrand ${_modelController.text}',
      brand: _selectedBrand,
      model: _modelController.text,
      year: _selectedYear,
      price: price,
      mileage: mileage,
      condition: _condition,
      fuelType: _fuelType,
      transmission: _transmission,
      bodyType: _bodyType,
      exteriorColor: _exteriorColor,
      interiorColor: _interiorColor,
      vin: _vinController.text.isNotEmpty ? _vinController.text : 'WP0AF2A88NS${DateTime.now().millisecondsSinceEpoch}',
      horsepower: hp,
      acceleration0To60: accel,
      topSpeedMph: topSpeed,
      rangeOrMpg: _fuelType == 'Electric' ? '340 mi range' : '20 MPG Hwy',
      engine: _engineController.text,
      drivetrain: 'RWD',
      location: _locationController.text,
      seller: const Seller(
        id: 'user-me',
        name: 'You (Verified Seller)',
        type: 'Private Seller',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
        rating: 5.0,
        reviewCount: 1,
        phone: '+1 (555) 789-0123',
        email: 'seller@autovault.com',
        location: 'California, US',
        responseTime: '< 5 mins',
        memberSinceYear: 2024,
        isVerified: true,
      ),
      images: [
        _selectedImageUrl,
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
      ],
      features: _selectedFeatures.toList(),
      isFeatured: false,
      isDeal: false,
      rating: 5.0,
      reviewCount: 0,
      isUserListed: true,
      description: _descriptionController.text,
    );

    store.addCar(newCar);

    // Show celebratory published sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 18),
              Text(
                'Listing Published Live!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your ${newCar.title} is now visible to thousands of verified buyers in AutoVault.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        widget.onNavigateTab(0); // Go to Explore
                      },
                      child: const Text('Go to Marketplace'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CarDetailsScreen(car: newCar)),
                        );
                      },
                      child: const Text('View My Listing'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brands = ['Porsche', 'Tesla', 'Mercedes-Benz', 'BMW', 'Audi', 'Lamborghini', 'Land Rover', 'Ford Performance', 'Ferrari'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Vehicle for Sale'),
        actions: [
          TextButton.icon(
            onPressed: _estimateValuation,
            icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.accentCyan, size: 16),
            label: const Text('Smart Valuation', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            // Section 1: Stock Image Picker
            Text(
              '1. Vehicle Photography (Stock Images)',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select high-res verified stock photography for your make or paste a custom image URL:',
              style: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),

            // Image Preview Card
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  CustomImage(
                    imageUrl: _selectedImageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                          SizedBox(width: 4),
                          Text('Primary Showcase Photo', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Preset Stock Images Selector
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _stockImagePresets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, idx) {
                  final preset = _stockImagePresets[idx];
                  final isSelected = _selectedImageUrl == preset['url'];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedImageUrl = preset['url']!;
                        _customImageUrlController.text = preset['url']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImage(
                          imageUrl: preset['url']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Custom image URL field
            TextField(
              controller: _customImageUrlController,
              decoration: InputDecoration(
                labelText: 'Or Paste Stock Image URL',
                prefixIcon: const Icon(Icons.link_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    if (_customImageUrlController.text.trim().isNotEmpty) {
                      setState(() {
                        _selectedImageUrl = _customImageUrlController.text.trim();
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 26),

            // Section 2: Vehicle Specs & Identification
            Text(
              '2. Vehicle Identification',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),

            // Brand dropdown
            DropdownButtonFormField<String>(
              value: _selectedBrand,
              decoration: const InputDecoration(labelText: 'Make / Brand'),
              dropdownColor: isDark ? AppColors.darkCard : Colors.white,
              items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedBrand = val);
              },
            ),

            const SizedBox(height: 12),

            // Model
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Model & Trim (e.g., 911 GT3 RS, M4 CS)'),
              validator: (v) => v == null || v.isEmpty ? 'Please enter car model' : null,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // Year & Mileage
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedYear,
                    decoration: const InputDecoration(labelText: 'Model Year'),
                    dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                    items: List.generate(8, (i) => 2025 - i)
                        .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedYear = val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _mileageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Mileage (miles)'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // Section 3: Performance & Technical Specs
            Text(
              '3. Performance & Drivetrain',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Horsepower (HP)'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _accelerationController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: '0-60 mph (sec)'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fuelType,
                    decoration: const InputDecoration(labelText: 'Fuel / Powertrain'),
                    dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                    items: ['Gasoline', 'Electric', 'Hybrid', 'Diesel']
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _fuelType = val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _transmission,
                    decoration: const InputDecoration(labelText: 'Transmission'),
                    dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                    items: ['Dual-Clutch', 'Automatic', 'Manual']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _transmission = val);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _engineController,
              decoration: const InputDecoration(labelText: 'Engine Specification'),
            ),

            const SizedBox(height: 26),

            // Section 4: Pricing & Instant Valuation
            Text(
              '4. Asking Price & Financing',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
              decoration: InputDecoration(
                labelText: 'Listing Price (\$ USD)',
                prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.accentCyan),
                  onPressed: _estimateValuation,
                ),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Please enter asking price' : null,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 8),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Price is negotiable for serious inquiries'),
              value: _isNegotiable,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isNegotiable = val ?? true),
            ),

            const SizedBox(height: 20),

            // Section 5: Features Checklist
            Text(
              '5. Installed Options & Features',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableFeatures.map((feat) {
                final isSelected = _selectedFeatures.contains(feat);
                return FilterChip(
                  label: Text(feat),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFeatures.add(feat);
                      } else {
                        _selectedFeatures.remove(feat);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Section 6: Location & Description
            Text(
              '6. Location & Seller Notes',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (City, State)',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Vehicle Overview / Maintenance History',
              ),
            ),

            const SizedBox(height: 30),

            // Publish CTA Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _publishCar,
                icon: const Icon(Icons.cloud_upload_rounded),
                label: const Text('Publish Verified Listing Live'),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
