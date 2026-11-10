import 'package:flutter/material.dart';
import '../models/property.dart';
import '../theme/app_colors.dart';
import '../state/car_store.dart';
import '../widgets/telebirr_paywall_modal.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({Key? key, required this.property}) : super(key: key);

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _activeImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = store.isFavorite(widget.property.id);
    final isUnlocked = store.isContactUnlocked(widget.property.id);
    final p = widget.property;

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable Content
          CustomScrollView(
            slivers: [
              // Image Carousel App Bar
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: isDark ? AppColors.obsidianBlack : Colors.white,
                leading: Container(
                  margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Listing link copied to clipboard')),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? AppColors.primaryAmber : Colors.white,
                        size: 20,
                      ),
                      onPressed: () => store.toggleFavorite(p.id),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: p.images.length,
                        onPageChanged: (i) => setState(() => _activeImageIndex = i),
                        itemBuilder: (ctx, i) {
                          return Image.network(
                            p.images[i],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (ctx, _, __) => Container(
                              color: AppColors.charcoalDark,
                              child: const Icon(Icons.home_work_outlined, size: 64, color: Colors.white30),
                            ),
                          );
                        },
                      ),
                      // Scrim Gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Photo Counter Badge
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_activeImageIndex + 1} / ${p.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Property Details Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Row: Verified & Listing Type
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: p.listingType == ListingType.forSale
                                  ? AppColors.obsidianBlack
                                  : AppColors.primaryAmber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.listingType == ListingType.forSale ? 'FOR SALE' : 'FOR RENT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.verifiedGreen.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.verifiedGreen.withOpacity(0.3)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.verified_rounded, size: 14, color: AppColors.verifiedGreen),
                                SizedBox(width: 4),
                                Text(
                                  'TIN Verified Listing',
                                  style: TextStyle(
                                    color: AppColors.verifiedGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Price
                      Text(
                        p.formattedPrice,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.primaryAmber : AppColors.primaryAmberDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        p.title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDarkPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Location & Wereda
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primaryAmber),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${p.address}, ${p.subCity}, ${p.city} (${p.wereda})',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: isDark ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Core Specs Grid (Beds, Baths, Area, Floor, Parking, Furnishing)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.charcoalCard : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                          ),
                        ),
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.4,
                          children: [
                            _buildSpecTile(Icons.bed_rounded, '${p.bedrooms} Beds', 'Bedrooms', isDark),
                            _buildSpecTile(Icons.bathtub_outlined, '${p.bathrooms} Baths', 'Bathrooms', isDark),
                            _buildSpecTile(Icons.square_foot_rounded, '${p.areaSqm.toInt()} m²', 'Total Area', isDark),
                            _buildSpecTile(Icons.layers_outlined, 'Floor ${p.floor}', 'Elevation', isDark),
                            _buildSpecTile(Icons.local_parking_rounded, '${p.parkingSpots} Bays', 'Parking', isDark),
                            _buildSpecTile(Icons.chair_outlined, p.furnishingStatus.split(' ').first, 'Furnishing', isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Ethiopian Essential Utilities
                      Text(
                        'Essential Ethiopian Infrastructure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.charcoalCard : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildUtilityRow(
                              Icons.water_drop_rounded,
                              '24/7 Water Reservoir / Dedicated Tank',
                              p.hasWater,
                              'Zero water interruption guarantee',
                              isDark,
                            ),
                            const Divider(height: 20),
                            _buildUtilityRow(
                              Icons.bolt_rounded,
                              'Automatic Backup Power Generator',
                              p.hasGenerator,
                              'Silent standby unit for continuous supply',
                              isDark,
                            ),
                            const Divider(height: 20),
                            _buildUtilityRow(
                              Icons.electric_bolt_rounded,
                              '3-Phase Stable Electric Supply',
                              p.hasElectricity,
                              'Heavy-duty residential wiring',
                              isDark,
                            ),
                            const Divider(height: 20),
                            _buildUtilityRow(
                              Icons.security_rounded,
                              'Gated Compound & 24/7 Guard Post',
                              p.hasSecurity,
                              'Perimeter security & access control',
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Property Description
                      Text(
                        'About This Property',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: isDark ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Premium Features Chips
                      Text(
                        'Highlights & Amenities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: p.features.map((f) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.charcoalDark : AppColors.cashmereBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded,
                                    size: 14, color: AppColors.primaryAmber),
                                const SizedBox(width: 6),
                                Text(
                                  f,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Verified Broker Card
                      Text(
                        'Broker & Verification Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.charcoalCard : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundImage: NetworkImage(p.seller.avatarUrl),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            p.seller.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? Colors.white : AppColors.textDarkPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.verified_rounded,
                                              size: 16, color: AppColors.primaryAmber),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        p.seller.type,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryAmber.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 14, color: AppColors.primaryAmber),
                                      const SizedBox(width: 3),
                                      Text(
                                        p.seller.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: AppColors.primaryAmberDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.charcoalDark : AppColors.cashmereBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'TIN: ${p.seller.tinNumber}',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                                  ),
                                  const Text('•', style: TextStyle(color: Colors.grey)),
                                  Text(
                                    'Lic: ${p.seller.licenseNumber}',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Bottom Contact Bar (Monetized Lead Reveal Paywall)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.charcoalDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: isUnlocked
                  ? Row(
                      children: [
                        // Unlocked: Direct Phone Call Button
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                            label: Text(
                              'Call ${p.seller.phone}',
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.verifiedGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dialing ${p.seller.phone}...')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Direct WhatsApp/SMS
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryAmber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.primaryAmber),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Opening secure broker inquiry channel...')),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        // Locked: Masked contact preview
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.lock_rounded, size: 12, color: AppColors.textDarkMuted),
                                SizedBox(width: 4),
                                Text(
                                  'Direct Contact Gated',
                                  style: TextStyle(fontSize: 11, color: AppColors.textDarkMuted, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+251 91 ••• ••${p.seller.phone.substring(p.seller.phone.length - 2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textDarkPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Telebirr Paywall Unlock Trigger Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                          label: const Text(
                            'Show Contact (20 ETB)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryAmber,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            TelebirrPaywallModal.show(
                              context,
                              listingId: p.id,
                              listingTitle: p.title,
                              agentName: p.seller.name,
                              onUnlocked: () => setState(() {}),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecTile(IconData icon, String value, String label, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryAmber),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textDarkPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildUtilityRow(IconData icon, String title, bool isAvailable, String subtitle, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.verifiedGreen.withOpacity(0.12) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isAvailable ? AppColors.verifiedGreen : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textDarkPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isAvailable ? Icons.check_circle_rounded : Icons.cancel_outlined,
          size: 18,
          color: isAvailable ? AppColors.verifiedGreen : Colors.grey,
        ),
      ],
    );
  }
}

