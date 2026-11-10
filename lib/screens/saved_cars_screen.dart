import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/car.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';
import '../widgets/property_card.dart';
import '../widgets/car_card.dart';
import 'car_details_screen.dart';

class SavedCarsScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const SavedCarsScreen({Key? key, required this.onNavigateTab}) : super(key: key);

  @override
  State<SavedCarsScreen> createState() => _SavedCarsScreenState();
}

class _SavedCarsScreenState extends State<SavedCarsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteProperties = store.favoriteProperties;
    final favoriteCars = store.favoriteCars;

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidianBlack : AppColors.cashmereBg,
      appBar: AppBar(
        title: const Text('Saved Favorites'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryAmber,
          unselectedLabelColor: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
          indicatorColor: AppColors.primaryAmber,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: [
            Tab(text: 'Houses (${favoriteProperties.length})'),
            Tab(text: 'Cars (${favoriteCars.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Saved Houses Tab
          favoriteProperties.isEmpty
              ? _buildEmptyView(
                  title: 'No Saved Properties',
                  subtitle: 'Tap the heart icon on any house, villa, or condo to save it here.',
                  isDark: isDark,
                  onBrowse: () {
                    store.setActiveCategory(CategoryMode.houses);
                    widget.onNavigateTab(0);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: favoriteProperties.length,
                    itemBuilder: (ctx, i) {
                      final p = favoriteProperties[i];
                      return PropertyCard(
                        property: p,
                        isFavorite: true,
                        onToggleFavorite: () => store.toggleFavorite(p.id),
                      );
                    },
                  ),
                ),

          // Saved Cars Tab
          favoriteCars.isEmpty
              ? _buildEmptyView(
                  title: 'No Saved Vehicles',
                  subtitle: 'Bookmark your favorite SUVs, sedans, or electric cars to inspect later.',
                  isDark: isDark,
                  onBrowse: () {
                    store.setActiveCategory(CategoryMode.cars);
                    widget.onNavigateTab(0);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: favoriteCars.length,
                    itemBuilder: (ctx, i) {
                      final car = favoriteCars[i];
                      return CarCard(
                        car: car,
                        isGrid: true,
                        isFavorite: true,
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
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyView({
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onBrowse,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryAmber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 48, color: AppColors.primaryAmber),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDarkPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textDarkMuted),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAmber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Explore Listings', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
