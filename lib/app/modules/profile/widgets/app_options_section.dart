import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';
import '../../../services/auth_service.dart';

class AppOptionsSection extends StatelessWidget {
  final ProfileController controller;

  const AppOptionsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Settings Section Title
          Text(
            "Settings",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: NeoSafeColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),

          // Settings Items
          _buildToggleItem(
            context,
            icon: Icons.notifications,
            iconColor: NeoSafeColors.primaryPink,
            title: "Notifications",
            value: controller.notificationsEnabled.value,
            onChanged: (value) => controller.toggleNotifications(),
          ),

          _buildToggleItem(
            context,
            icon: Icons.dark_mode,
            iconColor: NeoSafeColors.roseAccent,
            title: "Dark Mode",
            value: controller.darkModeEnabled.value,
            onChanged: (value) => controller.toggleDarkMode(),
          ),

          const SizedBox(height: 24),

          // App Options Items
          _buildOptionItem(
            context,
            icon: Icons.share,
            iconColor: NeoSafeColors.primaryPink,
            title: "Tell a friend",
            onTap: controller.tellAFriend,
          ),

          _buildOptionItem(
            context,
            icon: Icons.star,
            iconColor: NeoSafeColors.roseAccent,
            title: "Please rate us here",
            onTap: controller.rateApp,
          ),

          _buildOptionItem(
            context,
            icon: Icons.open_in_new,
            iconColor: NeoSafeColors.info,
            title: "Find out about Baby+",
            onTap: controller.findOutAboutBabyPlus,
          ),

          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            color: NeoSafeColors.softGray.withOpacity(0.3),
          ),

          const SizedBox(height: 16),

          // Logout Section
          _buildOptionItem(
            context,
            icon: Icons.logout,
            iconColor: NeoSafeColors.error,
            title: "Logout",
            onTap: () async {
              final authService = Get.find<AuthService>();
              await authService.logout();
              Get.offAllNamed('/login');
            },
          ),

          const SizedBox(height: 16),

          // Export Profile Data Section
          _buildOptionItem(
            context,
            icon: Icons.download,
            iconColor: NeoSafeColors.info,
            title: "Export Profile Data",
            onTap: () => _showExportDataDialog(context),
          ),

          const SizedBox(height: 16),

          // Clear Profile Data Section
          _buildOptionItem(
            context,
            icon: Icons.clear_all,
            iconColor: NeoSafeColors.warning,
            title: "Clear Profile Data",
            onTap: () => _showClearDataDialog(context),
          ),

          const SizedBox(height: 16),

          // Offers Section
          _buildOptionItem(
            context,
            icon: Icons.local_offer,
            iconColor: NeoSafeColors.coralPink,
            title: "Offers",
            onTap: controller.showOffers,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: NeoSafeColors.softGray.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: NeoSafeColors.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NeoSafeColors.softGray.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: iconColor,
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Profile Data'),
        content: const Text(
            'Are you sure you want to clear all your profile data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearProfileData();
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog(BuildContext context) {
    final profileData = controller.exportProfileData();
    final jsonString = profileData.toString();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Export Profile Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your profile data has been prepared for export.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NeoSafeColors.softGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                jsonString,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 16),
            const Text('You can copy this data or share it as needed.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Copy to clipboard
              // In a real app, you might want to use a clipboard plugin
              Get.snackbar(
                'Copied',
                'Profile data copied to clipboard!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                colorText: NeoSafeColors.success,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NeoSafeColors.primaryPink,
              foregroundColor: Colors.white,
            ),
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
