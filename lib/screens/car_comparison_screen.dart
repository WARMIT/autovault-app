import 'package:flutter/material.dart';
import '../models/car.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_image.dart';
import 'car_details_screen.dart';

class CarComparisonScreen extends StatelessWidget {
  final List<Car> cars;

  const CarComparisonScreen({Key? key, required this.cars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (cars.length < 2) {
      return Scaffold(
        appBar: AppBar(title: const Text('Compare Vehicles')),
        body: const Center(
          child: Text('Please select at least 2 vehicles to compare.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Side-by-Side Comparison'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Vehicle Visual Headers
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? AppColors.darkSurface : AppColors.lightCardElevated,
              child: Row(
                children: cars.map((car) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)),
                          );
                        },
                        child: Column(
                          children: [
                            CustomImage(
                              imageUrl: car.primaryImage,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              car.brand.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              car.model,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              car.formattedPrice,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Comparison Metrics
            _buildMetricComparisonSection(
              title: 'Performance & Speed',
              rows: [
                _buildRow(
                  '0-60 MPH Acceleration',
                  cars.map((c) => '${c.acceleration0To60} sec').toList(),
                  bestIndex: _findLowestIndex(cars.map((c) => c.acceleration0To60).toList()),
                  isDark: isDark,
                ),
                _buildRow(
                  'Peak Horsepower',
                  cars.map((c) => '${c.horsepower} HP').toList(),
                  bestIndex: _findHighestIndex(cars.map((c) => c.horsepower.toDouble()).toList()),
                  isDark: isDark,
                ),
                _buildRow(
                  'Top Speed',
                  cars.map((c) => '${c.topSpeedMph} mph').toList(),
                  bestIndex: _findHighestIndex(cars.map((c) => c.topSpeedMph.toDouble()).toList()),
                  isDark: isDark,
                ),
              ],
              isDark: isDark,
            ),

            const SizedBox(height: 16),

            _buildMetricComparisonSection(
              title: 'Financials & Value',
              rows: [
                _buildRow(
                  'Asking Price',
                  cars.map((c) => c.formattedPrice).toList(),
                  bestIndex: _findLowestIndex(cars.map((c) => c.price).toList()),
                  isDark: isDark,
                ),
                _buildRow(
                  'Est. Monthly EMI',
                  cars.map((c) => c.formattedMonthlyEmi()).toList(),
                  bestIndex: _findLowestIndex(cars.map((c) => c.calculateMonthlyEmi()).toList()),
                  isDark: isDark,
                ),
                _buildRow(
                  'Odometer Mileage',
                  cars.map((c) => c.formattedMileage).toList(),
                  bestIndex: _findLowestIndex(cars.map((c) => c.mileage.toDouble()).toList()),
                  isDark: isDark,
                ),
              ],
              isDark: isDark,
            ),

            const SizedBox(height: 16),

            _buildMetricComparisonSection(
              title: 'Powertrain & Architecture',
              rows: [
                _buildRow(
                  'Engine Type',
                  cars.map((c) => c.engine).toList(),
                  isDark: isDark,
                ),
                _buildRow(
                  'Drivetrain',
                  cars.map((c) => c.drivetrain).toList(),
                  isDark: isDark,
                ),
                _buildRow(
                  'Transmission',
                  cars.map((c) => c.transmission).toList(),
                  isDark: isDark,
                ),
                _buildRow(
                  'Fuel / Range',
                  cars.map((c) => c.rangeOrMpg).toList(),
                  isDark: isDark,
                ),
                _buildRow(
                  'Condition',
                  cars.map((c) => c.condition).toList(),
                  isDark: isDark,
                ),
              ],
              isDark: isDark,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  int _findLowestIndex(List<double> values) {
    int best = 0;
    for (int i = 1; i < values.length; i++) {
      if (values[i] < values[best]) best = i;
    }
    return best;
  }

  int _findHighestIndex(List<double> values) {
    int best = 0;
    for (int i = 1; i < values.length; i++) {
      if (values[i] > values[best]) best = i;
    }
    return best;
  }

  Widget _buildMetricComparisonSection({
    required String title,
    required List<Widget> rows,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary),
            ),
          ),
          Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildRow(String label, List<String> values, {int? bestIndex, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder.withOpacity(0.5) : AppColors.lightBorder.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: values.asMap().entries.map((entry) {
              final idx = entry.key;
              final val = entry.value;
              final isWinner = bestIndex != null && bestIndex == idx;

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isWinner ? AppColors.success.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isWinner ? Border.all(color: AppColors.success.withOpacity(0.5)) : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isWinner) ...[
                        const Icon(Icons.star_rounded, color: AppColors.success, size: 14),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          val,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isWinner ? FontWeight.w900 : FontWeight.w600,
                            color: isWinner
                                ? AppColors.success
                                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
