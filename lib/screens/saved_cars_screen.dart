import 'package:flutter/material.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';
import 'car_details_screen.dart';
import 'car_comparison_screen.dart';

class SavedCarsScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const SavedCarsScreen({Key? key, required this.onNavigateTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteCars = store.favoriteCars;
    final compareList = store.compareList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved & Comparison'),
        actions: [
          if (compareList.isNotEmpty)
            TextButton.icon(
              onPressed: () => store.clearCompare(),
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: const Text('Clear Compare'),
            ),
        ],
      ),
      body: favoriteCars.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.darkTextMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Your Garage is Empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on any vehicle to save it to your personal watchlist and compare specs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => onNavigateTab(0),
                      child: const Text('Explore Supercars & EVs'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Compare Bar if cars selected
                if (compareList.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${compareList.length} Vehicles in Comparison',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                compareList.map((c) => c.model).join(' vs '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CarComparisonScreen(cars: compareList),
                              ),
                            );
                          },
                          child: const Text('Compare', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                // Saved cars list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: favoriteCars.length,
                    itemBuilder: (context, index) {
                      final car = favoriteCars[index];
                      final isComparing = store.isInCompare(car.id);

                      return Stack(
                        children: [
                          CarCard(
                            car: car,
                            isFavorite: true,
                            onFavoriteToggle: () => store.toggleFavorite(car.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => CarDetailsScreen(car: car),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 14,
                            left: 14,
                            child: InkWell(
                              onTap: () => store.toggleCompare(car),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isComparing ? AppColors.accentCyan : Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isComparing ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                      color: isComparing ? Colors.black : Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isComparing ? 'Selected to Compare' : '+ Compare',
                                      style: TextStyle(
                                        color: isComparing ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
