import 'package:flutter/material.dart';
import '../state/car_store.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const ProfileScreen({Key? key, required this.onNavigateTab}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedRole = 'customer'; // 'customer', 'agent', 'auditor'

  @override
  Widget build(BuildContext context) {
    final store = CarStoreProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidianBlack : AppColors.cashmereBg,
      appBar: AppBar(
        title: const Text('Account & Institutional Portals'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: AppColors.primaryAmber,
            ),
            onPressed: () => store.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User KYC Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.charcoalCard : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.verifiedGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Amanuel Haile',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textDarkPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'TIN: 0049281729 • Addis Ababa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textLightMuted : AppColors.textDarkMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '✓ Certified Broker & Verified Account',
                            style: TextStyle(color: AppColors.verifiedGreen, fontSize: 10.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Role Switcher Tabs (3 Modes)
            Text(
              'Switch Active Workspace',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDarkPrimary,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.charcoalCard : AppColors.cashmereElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder),
              ),
              child: Row(
                children: [
                  _buildRoleTab('customer', 'Buyer / Client', Icons.person_rounded, isDark),
                  _buildRoleTab('agent', 'Broker CRM', Icons.real_estate_agent_rounded, isDark),
                  _buildRoleTab('auditor', 'Auditor / Gov', Icons.account_balance_rounded, isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // DYNAMIC VIEW BASED ON SELECTED ROLE
            if (_selectedRole == 'customer') ...[
              // CUSTOMER VIEW
              _buildSectionHeader('Buyer Preferences & Utilities', isDark),
              const SizedBox(height: 12),
              _buildSettingsTile(Icons.favorite_outline_rounded, 'My Saved Listings', 'Review your saved houses and cars', () {
                widget.onNavigateTab(2); // Go to Favorites tab
              }, isDark),
              _buildSettingsTile(Icons.history_rounded, 'Contact Unlock History', '1 listing contact unlocked via Telebirr', () {}, isDark),
              _buildSettingsTile(Icons.language_rounded, 'App Language', 'English (አማርኛ supported)', () {}, isDark),
              _buildSettingsTile(Icons.shield_outlined, 'KYC & ID Documents', 'National ID & TIN verified', () {}, isDark),
            ] else if (_selectedRole == 'agent') ...[
              // AGENT / BROKER DASHBOARD (Pages 9-10 of PDF)
              _buildSectionHeader('Agent Broker Operations (My Dashboard)', isDark),
              const SizedBox(height: 12),

              // KPI Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _buildKpiCard('Total Listings', '25', 'Active: 18 • Pending: 4', Icons.list_alt_rounded, isDark),
                  _buildKpiCard('Deals Closed', '3 Deals', 'Sold: 2 • Rented: 1', Icons.handshake_rounded, isDark),
                  _buildKpiCard('Gross Sales', 'ETB 42.5M', 'Turnover volume', Icons.payments_rounded, isDark),
                  _buildKpiCard('Commissions', 'ETB 850,000', 'Net payout balance', Icons.account_balance_wallet_rounded, isDark),
                ],
              ),
              const SizedBox(height: 16),

              // Broker Functions
              _buildSettingsTile(Icons.add_box_rounded, 'Post New Verified Listing', 'Create house or car listing', () {
                widget.onNavigateTab(1); // Go to Add tab
              }, isDark),
              _buildSettingsTile(Icons.people_outline_rounded, 'Lead CRM & Inquiries', '12 buyer contact unlocks recorded', () {}, isDark),
              _buildSettingsTile(Icons.receipt_long_rounded, 'Commission & Tax Reports', 'Download annual broker income statement', () {}, isDark),
            ] else ...[
              // GOVERNMENT / AUDITOR COMPLIANCE PORTAL (Pages 12-13 of PDF)
              _buildSectionHeader('Government & Auditor Compliance Portal', isDark),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.verifiedGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.verifiedGreen.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: AppColors.verifiedGreen, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Read-Only Regulatory Access for Ethiopian Revenue Authority (ERA) & Ministry of Trade.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.verifiedGreen),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Macro Platform Metrics
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildKpiCard('Registered Agents', '${store.auditorRegisteredAgents}', 'Active with TIN: ${store.auditorActiveAgents}', Icons.badge_rounded, isDark),
                  _buildKpiCard('Transactions', '${store.auditorTotalTransactions}', 'Platform total', Icons.sync_alt_rounded, isDark),
                  _buildKpiCard('Total Property Sales', 'ETB 450.2M', 'Residential & Commercial', Icons.apartment_rounded, isDark),
                  _buildKpiCard('Total Rental Value', 'ETB 82.4M', 'Lease contracts', Icons.key_rounded, isDark),
                ],
              ),
              const SizedBox(height: 14),

              // Tax & Commission Overview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.charcoalCard : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder),
                ),
                child: Column(
                  children: [
                    _buildTaxLine('Gross Broker Commission Pool', 'ETB 13,506,000.00', isDark),
                    const Divider(height: 16),
                    _buildTaxLine('Estimated ERA Withholding (20%)', 'ETB 2,701,200.00', isDark, isHighlight: true),
                    const Divider(height: 16),
                    _buildTaxLine('Audit Log Verification Status', '100% Cryptographically Logged', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                  label: const Text('Export Official ERA Audit Statement (PDF / CSV)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAmber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.verifiedGreen,
                        content: Text('Exporting official compliance statement to device...'),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleTab(String id, String label, IconData icon, bool isDark) {
    final isSelected = _selectedRole == id;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.charcoalDark : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: AppColors.primaryAmber, width: 1.2) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primaryAmber : AppColors.textDarkMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.textDarkPrimary)
                      : AppColors.textDarkMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: isDark ? Colors.white : AppColors.textDarkPrimary,
      ),
    );
  }

  Widget _buildKpiCard(String title, String val, String subtitle, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoalCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textDarkMuted, fontWeight: FontWeight.w700)),
              Icon(icon, size: 16, color: AppColors.primaryAmber),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textDarkMuted)),
        ],
      ),
    );
  }

  Widget _buildTaxLine(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? Colors.white70 : AppColors.textDarkSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isHighlight
                ? AppColors.primaryAmber
                : (isDark ? Colors.white : AppColors.textDarkPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, VoidCallback onTap, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoalCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.charcoalBorder : AppColors.cashmereBorder),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryAmber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryAmber, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDarkPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11.5, color: AppColors.textDarkMuted),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textDarkMuted),
      ),
    );
  }
}
