import 'package:flutter/material.dart';
import '../models/car.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';

class MakeOfferModal extends StatefulWidget {
  final Car car;

  const MakeOfferModal({Key? key, required this.car}) : super(key: key);

  static void show(BuildContext context, Car car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MakeOfferModal(car: car),
    );
  }

  @override
  State<MakeOfferModal> createState() => _MakeOfferModalState();
}

class _MakeOfferModalState extends State<MakeOfferModal> {
  late TextEditingController _amountController;
  final TextEditingController _noteController = TextEditingController();
  late double _currentOffer;

  @override
  void initState() {
    super.initState();
    _currentOffer = widget.car.price * 0.95; // Default 5% below asking
    _amountController = TextEditingController(text: _currentOffer.toInt().toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _applyPercentage(double pct) {
    setState(() {
      _currentOffer = widget.car.price * (1.0 - pct);
      _amountController.text = _currentOffer.toInt().toString();
    });
  }

  String _formatCurrency(num value) {
    return '\$${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final store = CarStoreProvider.of(context);

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_offer_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make an Official Offer',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Listed at ${widget.car.formattedPrice}',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick % buttons
          Row(
            children: [
              _buildQuickPill('-3% Offer', () => _applyPercentage(0.03), isDark),
              const SizedBox(width: 8),
              _buildQuickPill('-5% Offer', () => _applyPercentage(0.05), isDark),
              const SizedBox(width: 8),
              _buildQuickPill('-8% Offer', () => _applyPercentage(0.08), isDark),
              const SizedBox(width: 8),
              _buildQuickPill('Full Price', () => _applyPercentage(0.0), isDark),
            ],
          ),

          const SizedBox(height: 18),

          // Offer amount textfield
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            decoration: const InputDecoration(
              labelText: 'Offer Amount (\$ USD)',
              prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.primary),
            ),
            onChanged: (val) {
              final parsed = double.tryParse(val.replaceAll(',', ''));
              if (parsed != null) {
                setState(() => _currentOffer = parsed);
              }
            },
          ),

          const SizedBox(height: 12),

          // Note to seller
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Message to Seller (Optional)',
              hintText: 'e.g., Ready to close immediately with cash/pre-approved wire.',
              prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
            ),
          ),

          const SizedBox(height: 22),

          // Submit offer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final offer = double.tryParse(_amountController.text.trim()) ?? _currentOffer;
                store.makeOffer(
                  car: widget.car,
                  offerAmount: offer,
                  note: _noteController.text.trim(),
                );
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    content: Text(
                      'Offer of ${_formatCurrency(offer)} submitted to ${widget.car.seller.name}!',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              child: Text('Submit ${_formatCurrency(_currentOffer)} Offer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPill(String label, VoidCallback onTap, bool isDark) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCardElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
