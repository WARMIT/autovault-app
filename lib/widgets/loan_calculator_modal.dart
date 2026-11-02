import 'dart:math';
import 'package:flutter/material.dart';
import '../models/car.dart';
import '../theme/app_colors.dart';

class LoanCalculatorModal extends StatefulWidget {
  final Car car;

  const LoanCalculatorModal({Key? key, required this.car}) : super(key: key);

  static void show(BuildContext context, Car car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LoanCalculatorModal(car: car),
    );
  }

  @override
  State<LoanCalculatorModal> createState() => _LoanCalculatorModalState();
}

class _LoanCalculatorModalState extends State<LoanCalculatorModal> {
  late double _price;
  double _downPaymentPercent = 0.15; // 15%
  int _months = 60; // 60 months (5 years)
  double _apr = 5.9; // 5.9%

  @override
  void initState() {
    super.initState();
    _price = widget.car.price;
  }

  double get downPaymentAmount => _price * _downPaymentPercent;
  double get loanPrincipal => _price - downPaymentAmount;

  double get monthlyPayment {
    final monthlyRate = (_apr / 100) / 12;
    if (monthlyRate == 0) return loanPrincipal / _months;
    final emi = (loanPrincipal * monthlyRate * pow(1 + monthlyRate, _months)) /
        (pow(1 + monthlyRate, _months) - 1);
    return emi;
  }

  double get totalPayment => (monthlyPayment * _months) + downPaymentAmount;
  double get totalInterest => (monthlyPayment * _months) - loanPrincipal;

  String _formatCurrency(num value) {
    return '\$${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final termOptions = [24, 36, 48, 60, 72];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finance & EMI Calculator',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    widget.car.title,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Monthly Payment Big Highlight
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                    : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESTIMATED MONTHLY PAYMENT',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatCurrency(monthlyPayment)}/mo',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      '${_months} months loan @ ${_apr.toStringAsFixed(1)}% APR',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.speed_rounded, color: AppColors.primary, size: 28),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Down Payment Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Down Payment (${(_downPaymentPercent * 100).toInt()}%)',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                _formatCurrency(downPaymentAmount),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Slider(
            value: _downPaymentPercent,
            min: 0.05,
            max: 0.50,
            divisions: 9,
            activeColor: AppColors.primary,
            inactiveColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            onChanged: (val) {
              setState(() {
                _downPaymentPercent = val;
              });
            },
          ),

          const SizedBox(height: 12),

          // Loan Term Chips
          Text(
            'Loan Duration',
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: termOptions.map((term) {
              final isSelected = _months == term;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _months = term),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkCard : AppColors.lightCardElevated),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${term}m',
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Interest Rate Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated APR Rate',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_apr.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Slider(
            value: _apr,
            min: 2.9,
            max: 12.9,
            divisions: 20,
            activeColor: AppColors.accentCyan,
            inactiveColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            onChanged: (val) {
              setState(() {
                _apr = val;
              });
            },
          ),

          const SizedBox(height: 14),

          // Cost Breakdown Summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCardElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCol('Principal', _formatCurrency(loanPrincipal), isDark),
                Container(height: 24, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildSummaryCol('Total Interest', _formatCurrency(totalInterest), isDark),
                Container(height: 24, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildSummaryCol('Total Cost', _formatCurrency(totalPayment), isDark),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    content: Text(
                      'Pre-approval submitted for ${widget.car.title}! Our finance concierge will contact you.',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              child: const Text('Apply for Instant Pre-Approval'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCol(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
