import 'package:flutter/material.dart';
import '../models/property.dart';
import '../theme/app_colors.dart';
import '../screens/property_details_screen.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.isFavorite,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => PropertyDetailsScreen(property: property),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.charcoalCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Overlays
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.25,
                  child: Image.network(
                    property.primaryImage,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) => Container(
                      color: isDark ? AppColors.charcoalDark : AppColors.cashmereElevated,
                      child: const Center(
                        child: Icon(Icons.home_work_outlined, size: 36, color: AppColors.textDarkMuted),
                      ),
                    ),
                  ),
                ),

                // Top Gradients & Badges
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: property.listingType == ListingType.forSale
                          ? AppColors.obsidianBlack.withOpacity(0.85)
                          : AppColors.primaryAmber.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(8),
                      backdropFilter: const ColorFilter.mode(Colors.black, BlendMode.dst),
                    ),
                    child: Text(
                      property.listingType == ListingType.forSale ? 'FOR SALE' : 'FOR RENT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onToggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: isFavorite ? AppColors.primaryAmber : Colors.white,
                      ),
                    ),
                  ),
                ),

                // Bottom Utilities Preview
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: Row(
                    children: [
                      if (property.hasWater)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.water_drop_rounded, size: 12, color: Colors.cyanAccent),
                        ),
                      if (property.hasGenerator)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.bolt_rounded, size: 12, color: Colors.amberAccent),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verified Badge Row
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 14, color: AppColors.primaryAmber),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Listing',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.primaryAmber : AppColors.primaryAmberDark,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        property.typeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price in ETB
                  Text(
                    property.formattedPrice,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.textDarkPrimary,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Title
                  Text(
                    property.title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Specs Row (Beds / Baths / Sqm)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.charcoalDark : AppColors.cashmereElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      property.specsSummary,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textDarkMuted),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          property.subCity,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

