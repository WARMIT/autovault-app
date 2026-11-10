import 'package:flutter/material.dart';
import '../models/car.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_image.dart';
import '../widgets/loan_calculator_modal.dart';
import '../widgets/test_drive_modal.dart';
import '../widgets/make_offer_modal.dart';
import '../widgets/telebirr_paywall_modal.dart';
import 'chat_screen.dart';

class CarDetailsScreen extends StatefulWidget {
  final Car car;

  const CarDetailsScreen({Key? key, required this.car}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  bool _is360Mode = false;
  double _spinOffset = 0.0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = store.isFavorite(widget.car.id);
    final isInCompare = store.isInCompare(widget.car.id);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Image Header & App Bar
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.65),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.65),
                    child: IconButton(
                      icon: Icon(
                        isInCompare ? Icons.compare_arrows_rounded : Icons.add_chart_rounded,
                        color: isInCompare ? AppColors.accentCyan : Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        store.toggleCompare(widget.car);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isInCompare
                                  ? 'Removed from comparison'
                                  : 'Added to comparison (${store.compareList.length}/3 cars)',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.65),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? const Color(0xFFFF3366) : Colors.white,
                        size: 20,
                      ),
                      onPressed: () => store.toggleFavorite(widget.car.id),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Photo Gallery or 360 Spin Mode
                      if (!_is360Mode) ...[
                        PageView.builder(
                          controller: _pageController,
                          itemCount: widget.car.images.length,
                          onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                          itemBuilder: (context, index) {
                            return CustomImage(
                              imageUrl: widget.car.images[index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        // Dots Indicator
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.car.images.length,
                              (idx) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentImageIndex == idx ? 24 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == idx ? AppColors.primary : Colors.white54,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // 360 Spin Simulator
                        GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              _spinOffset += details.primaryDelta ?? 0;
                            });
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CustomImage(
                                imageUrl: widget.car.primaryImage,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                color: Colors.black38,
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.threesixty_rounded, color: AppColors.accentCyan, size: 54),
                                      SizedBox(height: 8),
                                      Text(
                                        'Interactive 360° Studio View',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      Text(
                                        'Drag horizontally to inspect every angle',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // 360 Toggle Button
                      Positioned(
                        bottom: 18,
                        right: 18,
                        child: InkWell(
                          onTap: () => setState(() => _is360Mode = !_is360Mode),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _is360Mode ? AppColors.accentCyan : Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.threesixty_rounded,
                                  size: 16,
                                  color: _is360Mode ? Colors.black : Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _is360Mode ? 'Gallery' : '360° View',
                                  style: TextStyle(
                                    color: _is360Mode ? Colors.black : Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
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

              // Car Details Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand & Condition Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.car.brand.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : AppColors.lightCardElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                            ),
                            child: Text(
                              widget.car.condition,
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.car.rating} (${widget.car.reviewCount} reviews)',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        widget.car.title,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Location & VIN
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          const SizedBox(width: 4),
                          Text(
                            widget.car.location,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text('•', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          const SizedBox(width: 14),
                          Text(
                            'VIN: ${widget.car.vin.substring(0, 11)}...',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Price and Financing Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCardElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.car.originalPrice != null)
                                  Text(
                                    widget.car.formattedOriginalPrice,
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                Text(
                                  widget.car.formattedPrice,
                                  style: TextStyle(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Estimated from ${widget.car.formattedMonthlyEmi()}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            OutlinedButton.icon(
                              onPressed: () => LoanCalculatorModal.show(context, widget.car),
                              icon: const Icon(Icons.calculate_outlined, size: 16),
                              label: const Text('Calculate EMI'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Performance Highlights Grid
                      Text(
                        'Performance Metrics',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildGaugeCard('0-60 MPH', '${widget.car.acceleration0To60}s', 'Acceleration', Icons.flash_on_rounded, isDark),
                          const SizedBox(width: 10),
                          _buildGaugeCard('HORSEPOWER', '${widget.car.horsepower}', 'Peak Power', Icons.speed_rounded, isDark),
                          const SizedBox(width: 10),
                          _buildGaugeCard('TOP SPEED', '${widget.car.topSpeedMph}', 'mph Max', Icons.av_timer_rounded, isDark),
                          const SizedBox(width: 10),
                          _buildGaugeCard('EFFICIENCY', widget.car.rangeOrMpg.split(' ').first, 'Range / MPG', Icons.battery_charging_full_rounded, isDark),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Technical Specifications
                      Text(
                        'Technical Specifications',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow('Engine / Powertrain', widget.car.engine, isDark),
                            _buildDivider(isDark),
                            _buildSpecRow('Transmission', widget.car.transmission, isDark),
                            _buildDivider(isDark),
                            _buildSpecRow('Drivetrain', widget.car.drivetrain, isDark),
                            _buildDivider(isDark),
                            _buildSpecRow('Odometer Mileage', widget.car.formattedMileage, isDark),
                            _buildDivider(isDark),
                            _buildSpecRow('Exterior Color', widget.car.exteriorColor, isDark),
                            _buildDivider(isDark),
                            _buildSpecRow('Interior Trim', widget.car.interiorColor, isDark),
                            _buildDivider(isDark),
                            _buildSpecRow('VIN Number', widget.car.vin, isDark),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Verified Features Checklist
                      Text(
                        'Installed Equipment & Features',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.car.features.map((feat) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightCardElevated,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  feat,
                                  style: TextStyle(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Vehicle History & Overview',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.car.description,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Seller Profile Card
                      Text(
                        'Listed by',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomImage(
                                  imageUrl: widget.car.seller.avatarUrl,
                                  width: 52,
                                  height: 52,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.car.seller.name,
                                            style: TextStyle(
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.verified_rounded, color: AppColors.accentCyan, size: 16),
                                        ],
                                      ),
                                      Text(
                                        '${widget.car.seller.type} • Since ${widget.car.seller.memberSinceYear}',
                                        style: TextStyle(
                                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${widget.car.seller.rating} (${widget.car.seller.reviewCount} sales)',
                                            style: TextStyle(
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '⚡ Responds in ${widget.car.seller.responseTime}',
                                            style: const TextStyle(
                                              color: AppColors.success,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => ChatScreen(car: widget.car),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                    label: const Text('Direct Chat'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      if (!store.isContactUnlocked(widget.car.id)) {
                                        TelebirrPaywallModal.show(
                                          context,
                                          listingId: widget.car.id,
                                          listingTitle: widget.car.title,
                                          agentName: widget.car.seller.name,
                                          onUnlocked: () => setState(() {}),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Calling ${widget.car.seller.phone}...'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      store.isContactUnlocked(widget.car.id)
                                          ? Icons.phone_outlined
                                          : Icons.lock_open_rounded,
                                      size: 16,
                                    ),
                                    label: Text(
                                      store.isContactUnlocked(widget.car.id)
                                          ? 'Call Seller'
                                          : 'Unlock Contact',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom Actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => TestDriveModal.show(context, widget.car),
                      child: const Text('Book Test Drive'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => MakeOfferModal.show(context, widget.car),
                      child: const Text('Make an Offer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeCard(String title, String value, String subtitle, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCardElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }
}
