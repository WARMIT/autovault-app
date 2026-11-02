import 'package:flutter/material.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';
import 'car_details_screen.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(num value) {
    return '\$${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredCars = store.filteredCars;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Explore'),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              color: _showFilters ? AppColors.primary : null,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
          if (store.searchQuery.isNotEmpty || store.selectedBrand != 'All Makes' || store.selectedCategory != 'All')
            TextButton(
              onPressed: () {
                _searchController.clear();
                store.resetFilters();
              },
              child: const Text('Reset', style: TextStyle(color: AppColors.primary)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by model, brand, spec, or city...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          store.setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (val) => store.setSearchQuery(val),
            ),
          ),

          // Collapsible Filter Drawer / Box
          if (_showFilters)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        '${_formatCurrency(store.priceRange.start)} - ${_formatCurrency(store.priceRange.end)}',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: store.priceRange,
                    min: 10000,
                    max: 350000,
                    divisions: 34,
                    activeColor: AppColors.primary,
                    inactiveColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    onChanged: (values) => store.setPriceRange(values),
                  ),

                  const SizedBox(height: 8),

                  // Fuel & Transmission Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: store.selectedFuelType ?? 'All',
                          decoration: const InputDecoration(labelText: 'Fuel Type', contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                          items: ['All', 'Gasoline', 'Electric', 'Hybrid']
                              .map((f) => DropdownMenuItem(value: f, child: Text(f, style: const TextStyle(fontSize: 12))))
                              .toList(),
                          onChanged: (val) => store.setFuelType(val == 'All' ? null : val),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: store.selectedTransmission ?? 'All',
                          decoration: const InputDecoration(labelText: 'Transmission', contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                          items: ['All', 'Dual-Clutch', 'Automatic', 'Manual']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                              .toList(),
                          onChanged: (val) => store.setTransmission(val == 'All' ? null : val),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Sort by dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sort by:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: store.sortBy,
                        underline: const SizedBox(),
                        dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                        items: [
                          'Recommended',
                          'Price: Low to High',
                          'Price: High to Low',
                          'Year: Newest',
                          'Mileage: Lowest',
                        ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                        onChanged: (val) {
                          if (val != null) store.setSortBy(val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Results Count Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredCars.length} vehicles found',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Sort: ${store.sortBy}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: filteredCars.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.car_crash_outlined, size: 64, color: AppColors.darkTextMuted),
                          const SizedBox(height: 16),
                          Text(
                            'No vehicles match your criteria',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try expanding your price range, clearing filters, or searching for another keyword.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              store.resetFilters();
                            },
                            child: const Text('Reset All Filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filteredCars.length,
                    itemBuilder: (context, index) {
                      final car = filteredCars[index];
                      return CarCard(
                        car: car,
                        isFavorite: store.isFavorite(car.id),
                        onFavoriteToggle: () => store.toggleFavorite(car.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => CarDetailsScreen(car: car),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
