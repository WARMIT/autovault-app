import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/car_store.dart';

class TelebirrPaywallModal extends StatefulWidget {
  final String listingId;
  final String listingTitle;
  final String agentName;
  final VoidCallback onUnlocked;

  const TelebirrPaywallModal({
    Key? key,
    required this.listingId,
    required this.listingTitle,
    required this.agentName,
    required this.onUnlocked,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String listingId,
    required String listingTitle,
    required String agentName,
    required VoidCallback onUnlocked,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TelebirrPaywallModal(
        listingId: listingId,
        listingTitle: listingTitle,
        agentName: agentName,
        onUnlocked: onUnlocked,
      ),
    );
  }

  @override
  State<TelebirrPaywallModal> createState() => _TelebirrPaywallModalState();
}

class _TelebirrPaywallModalState extends State<TelebirrPaywallModal> {
  String _selectedProvider = 'telebirr'; // 'telebirr', 'cbe', 'mpesa'
  bool _isProcessing = false;
  bool _isSuccess = false;
  final TextEditingController _phoneController =
      TextEditingController(text: '0911234567');

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate instant Ethiopian payment gateway USSD confirmation
    await Future.delayed(const Duration(milliseconds: 1600));

    if (mounted) {
      final store = CarStoreProvider.of(context);
      store.unlockContact(widget.listingId);

      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        widget.onUnlocked();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.verifiedGreen,
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Contact info for ${widget.agentName} unlocked successfully!'),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoalCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryAmber.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_open_rounded, color: AppColors.primaryAmber, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unlock Broker Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Official Phone & Direct Email for ${widget.agentName}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Pricing Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.charcoalDark : AppColors.cashmereBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'One-Time Unlock Fee',
                      style: TextStyle(fontSize: 12, color: AppColors.textDarkMuted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ETB 20.00',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.primaryAmber : AppColors.primaryAmberDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Instant Verification',
                    style: TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment Methods
          const Text(
            'Select Ethiopian Payment Method',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // Telebirr Option
          _buildProviderTile(
            id: 'telebirr',
            name: 'Telebirr (Ethio Telecom)',
            subtitle: 'Instant USSD Push Notification',
            color: const Color(0xFF005BAC),
            icon: Icons.phone_android_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // CBE Birr Option
          _buildProviderTile(
            id: 'cbe',
            name: 'CBE Birr (Commercial Bank)',
            subtitle: 'Direct Account / Wallet Deduction',
            color: const Color(0xFF6B1D73),
            icon: Icons.account_balance_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // M-Pesa Option
          _buildProviderTile(
            id: 'mpesa',
            name: 'M-Pesa (Safaricom Ethiopia)',
            subtitle: 'Mobile Wallet PIN confirmation',
            color: const Color(0xFF00843D),
            icon: Icons.mobile_friendly_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isProcessing || _isSuccess ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAmber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isProcessing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Connecting to Telebirr...', style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    )
                  : _isSuccess
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Payment Confirmed!', style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        )
                      : Text(
                          'Pay ETB 20 with ${_selectedProvider.toUpperCase()}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderTile({
    required String id,
    required String name,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedProvider == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.charcoalDark : AppColors.cashmereBg)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryAmber : (isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13.5,
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
            Radio<String>(
              value: id,
              groupValue: _selectedProvider,
              activeColor: AppColors.primaryAmber,
              onChanged: (val) {
                if (val != null) setState(() => _selectedProvider = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}

