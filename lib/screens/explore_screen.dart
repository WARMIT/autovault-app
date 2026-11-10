import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/car.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';
import '../widgets/property_card.dart';
import '../widgets/car_card.dart';
import 'car_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const ExploreScreen({Key? key, required this.onTabChange}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showLocationPicker(BuildContext context, CarStore store) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.charcoalCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.primaryAmber),
                const SizedBox(width: 8),
                Text(
                  'Select Addis Ababa Sub-City / Region',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textDarkPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: store.availableSubCities.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final subCity = store.availableSubCities[i];
                  final isSelected = store.selectedSubCity == subCity;

                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      subCity,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryAmber
                            : (isDark ? Colors.white : AppColors.textDarkPrimary),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryAmber, size: 20)
                        : null,
                    onTap: () {
                      store.setSelectedSubCity(subCity);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, CarStore store) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.charcoalCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Listings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textDarkPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    store.setPropertyListingTypeFilter(null);
                    store.setSelectedBrand('All Makes');
                    store.setSelectedSubCity('All Sub-cities');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset All', style: TextStyle(color: AppColors.primaryAmber)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (store.activeCategory == CategoryMode.houses) ...[
              const Text('Listing Type', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 10),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: store.propertyListingTypeFilter == null,
                    selectedColor: AppColors.primaryAmber.withOpacity(0.2),
                    onSelected: (_) => store.setPropertyListingTypeFilter(null),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('For Sale'),
                    selected: store.propertyListingTypeFilter == ListingType.forSale,
                    selectedColor: AppColors.primaryAmber.withOpacity(0.2),
                    onSelected: (_) => store.setPropertyListingTypeFilter(ListingType.forSale),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('For Rent'),
                    selected: store.propertyListingTypeFilter == ListingType.forRent,
                    selectedColor: AppColors.primaryAmber.withOpacity(0.2),
                    onSelected: (_) => store.setPropertyListingTypeFilter(ListingType.forRent),
                  ),
                ],
              ),
            ] else ...[
              const Text('Popular Vehicle Brands', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: ['All Makes', 'Toyota', 'Hyundai', 'Suzuki', 'Mercedes-Benz'].map((brand) {
                  final isSelected = store.selectedBrand == brand;
                  return ChoiceChip(
                    label: Text(brand),
                    selected: isSelected,
                    selectedColor: AppColors.primaryAmber.withOpacity(0.2),
                    onSelected: (_) => store.setSelectedBrand(brand),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAmber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Apply Filter', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isHousesMode = store.activeCategory == CategoryMode.houses;
    final properties = store.filteredProperties;
    final cars = store.filteredCars;

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidianBlack : AppColors.cashmereBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Top App Bar (Brand Logo, Location Dropdown Pill, Filter Button)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    // Brand Logo Mark with Amber Ring Accent
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryAmber, width: 2.2),
                            color: isDark ? AppColors.charcoalDark : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAmber.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.obsidianBlack,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AllSell',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : AppColors.obsidianBlack,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              'Connect & Simplify',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryAmber,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(),

                    // City / Sub-City Selector Pill
                    GestureDetector(
                      onTap: () => _showLocationPicker(context, store),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.charcoalCard : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primaryAmber),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 110),
                              child: Text(
                                store.selectedSubCity == 'All Sub-cities'
                                    ? store.selectedCity
                                    : store.selectedSubCity,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.textDarkPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textDarkMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Filter Button
                    GestureDetector(
                      onTap: () => _showFilterSheet(context, store),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.charcoalCard : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.tune_rounded, size: 14, color: isDark ? Colors.white : AppColors.textDarkPrimary),
                            const SizedBox(width: 4),
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.textDarkPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Universal Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.charcoalCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => store.setSearchQuery(val),
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.white : AppColors.textDarkPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: isHousesMode
                          ? 'Search houses, villas or apartments...'
                          : 'Search Toyota, Hyundai, SUVs or cars...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textDarkMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryAmber, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              onPressed: () {
                                _searchController.clear();
                                store.setSearchQuery('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Segmented Dual-Category Switcher: [ Houses ] | [ Cars ]
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.charcoalCard : AppColors.cashmereElevated,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Houses Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => store.setActiveCategory(CategoryMode.houses),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isHousesMode
                                  ? (isDark ? AppColors.charcoalDark : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: isHousesMode
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                              border: isHousesMode
                                  ? Border.all(color: AppColors.primaryAmber.withOpacity(0.4), width: 1.2)
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_work_rounded,
                                  size: 18,
                                  color: isHousesMode ? AppColors.primaryAmber : AppColors.textDarkMuted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Houses',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isHousesMode ? FontWeight.w800 : FontWeight.w600,
                                    color: isHousesMode
                                        ? (isDark ? Colors.white : AppColors.textDarkPrimary)
                                        : AppColors.textDarkMuted,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isHousesMode
                                        ? AppColors.primaryAmber.withOpacity(0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${store.allProperties.length}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isHousesMode ? AppColors.primaryAmberDark : AppColors.textDarkMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Cars Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => store.setActiveCategory(CategoryMode.cars),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isHousesMode
                                  ? (isDark ? AppColors.charcoalDark : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: !isHousesMode
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                              border: !isHousesMode
                                  ? Border.all(color: AppColors.primaryAmber.withOpacity(0.4), width: 1.2)
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_car_filled_rounded,
                                  size: 18,
                                  color: !isHousesMode ? AppColors.primaryAmber : AppColors.textDarkMuted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cars',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: !isHousesMode ? FontWeight.w800 : FontWeight.w600,
                                    color: !isHousesMode
                                        ? (isDark ? Colors.white : AppColors.textDarkPrimary)
                                        : AppColors.textDarkMuted,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: !isHousesMode
                                        ? AppColors.primaryAmber.withOpacity(0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${store.allCars.length}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: !isHousesMode ? AppColors.primaryAmberDark : AppColors.textDarkMuted,
                                    ),
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
              ),
            ),

            // 4. Promotional Banner Slot ("Featured this week")
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroBannerGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAmber.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primaryAmber,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'FEATURED THIS WEEK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Verified Diplomatic Properties & Hybrid Imports in Addis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pre-audited TIN titles with zero broker fraud.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars_rounded, color: AppColors.primaryAmber, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Section Title & Counter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHousesMode ? 'Verified Houses & Condos' : 'Verified Vehicles & SUVs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.textDarkPrimary,
                      ),
                    ),
                    Text(
                      '${isHousesMode ? properties.length : cars.length} Listings',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDarkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. Responsive 2-Column Listing Grid
            if (isHousesMode)
              properties.isEmpty
                  ? _buildEmptyState(isDark, store)
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final p = properties[i];
                            return PropertyCard(
                              property: p,
                              isFavorite: store.isFavorite(p.id),
                              onToggleFavorite: () => store.toggleFavorite(p.id),
                            );
                          },
                          childCount: properties.length,
                        ),
                      ),
                    )
            else
              cars.isEmpty
                  ? _buildEmptyState(isDark, store)
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final car = cars[i];
                            return CarCard(
                              car: car,
                              isGrid: true,
                              isFavorite: store.isFavorite(car.id),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (c) => CarDetailsScreen(car: car),
                                  ),
                                );
                              },
                              onFavoriteToggle: () => store.toggleFavorite(car.id),
                            );
                          },
                          childCount: cars.length,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, CarStore store) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 54, color: AppColors.textDarkMuted),
            const SizedBox(height: 14),
            Text(
              'No listings found in ${store.selectedSubCity}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textDarkPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try changing your location filter to "All Sub-cities" or clearing your search.',
              style: TextStyle(fontSize: 13, color: AppColors.textDarkMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                store.setSearchQuery('');
                store.setSelectedSubCity('All Sub-cities');
                store.setPropertyListingTypeFilter(null);
                store.setSelectedBrand('All Makes');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAmber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reset All Filters', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
