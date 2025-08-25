import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/const/risk_factor.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/risk_factor_view.dart';
import 'package:babysafe/app/routes/app_pages.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/auth_service.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:babysafe/app/data/models/user_model.dart';

class RiskFactorCard extends StatelessWidget {
  const RiskFactorCard({super.key});

  Map<String, List<String>> _getUserSpecificRiskFactors(UserModel? user) {
    if (user == null) return {};

    final Map<String, List<String>> userRiskFactors = {};

    // Check for Rh-negative blood group
    if (user.motherBloodGroup?.contains('-') == true) {
      userRiskFactors['Rh-negative Mothers'] =
          riskFactorGroups['Rh-negative Mothers'] ?? [];
    }

    // Check for relation-based risk factors
    switch (user.relation?.toLowerCase()) {
      case 'first cousin':
        userRiskFactors['First Cousin Marriage'] =
            riskFactorGroups['First Cousin Marriage'] ?? [];
        break;
      case 'second cousin':
        userRiskFactors['Second Cousin Marriage'] =
            riskFactorGroups['Second Cousin Marriage'] ?? [];
        break;
      case 'relative':
        userRiskFactors['Relative Marriage'] =
            riskFactorGroups['Relative Marriage'] ?? [];
        break;
      case 'no relation':
        userRiskFactors['No Relation'] = riskFactorGroups['No Relation'] ?? [];
        break;
    }

    // Add other risk factors that are always relevant
    if (riskFactorGroups.containsKey('Multiple Pregnancy')) {
      userRiskFactors['Multiple Pregnancy'] =
          riskFactorGroups['Multiple Pregnancy']!;
    }

    return userRiskFactors;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();

    return GetX<AuthService>(
      builder: (authService) {
        final user = authService.currentUser.value;
        final userRiskFactors = _getUserSpecificRiskFactors(user);
        final hasRiskFactors = userRiskFactors.isNotEmpty;
        final totalRiskFactors = userRiskFactors.values
            .fold<int>(0, (sum, factors) => sum + factors.length);

        return GestureDetector(
          onTap: () {
            _showBloodGroupBottomSheet(context);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasRiskFactors
                    ? [
                        NeoSafeColors.warning.withOpacity(0.1),
                        themeService.getPaleColor().withOpacity(0.8),
                        themeService.getLightColor().withOpacity(0.6),
                      ]
                    : [
                        NeoSafeColors.success.withOpacity(0.1),
                        themeService.getPaleColor().withOpacity(0.7),
                        themeService.getPaleColor().withOpacity(0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: hasRiskFactors
                    ? NeoSafeColors.warning.withOpacity(0.2)
                    : NeoSafeColors.success.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: hasRiskFactors
                      ? NeoSafeColors.warning.withOpacity(0.15)
                      : NeoSafeColors.success.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: hasRiskFactors
                      ? NeoSafeColors.warning.withOpacity(0.05)
                      : NeoSafeColors.success.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative background elements
                // Positioned(
                //   top: -20,
                //   right: -20,
                //   child: Container(
                //     width: 80,
                //     height: 80,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       gradient: RadialGradient(
                //         colors: [
                //           hasRiskFactors
                //               ? NeoSafeColors.warning.withOpacity(0.1)
                //               : NeoSafeColors.success.withOpacity(0.1),
                //           Colors.transparent,
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: -30,
                //   left: -30,
                //   child: Container(
                //     width: 100,
                //     height: 100,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       gradient: RadialGradient(
                //         colors: [
                //           NeoSafeColors.primaryPink.withOpacity(0.08),
                //           Colors.transparent,
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Header Row
                      Row(
                        children: [
                          // Status icon with gradient background
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: hasRiskFactors
                                    ? [
                                        NeoSafeColors.warning.withOpacity(0.9),
                                        NeoSafeColors.warning.withOpacity(0.7),
                                      ]
                                    : [
                                        NeoSafeColors.success.withOpacity(0.9),
                                        NeoSafeColors.success.withOpacity(0.7),
                                      ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: hasRiskFactors
                                      ? NeoSafeColors.warning.withOpacity(0.3)
                                      : NeoSafeColors.success.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              hasRiskFactors
                                  ? Icons.warning_amber_rounded
                                  : Icons.health_and_safety_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Title with enhanced styling
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "risk_factors".tr,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: NeoSafeColors.primaryText,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasRiskFactors
                                      ? "tap_to_review_factors".tr
                                      : "all_clear_for_now".tr,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status indicator with count
                          if (hasRiskFactors)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: NeoSafeColors.warning,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        NeoSafeColors.warning.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                "$totalRiskFactors",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: NeoSafeColors.success.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: NeoSafeColors.success,
                                size: 16,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Content based on risk factor status
                      if (hasRiskFactors)
                        _buildRiskFactorsList(context, theme, userRiskFactors),

                      // Action indicator
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: NeoSafeColors.creamWhite.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                themeService.getPrimaryColor().withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.touch_app_rounded,
                              color: themeService.getPrimaryColor(),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              hasRiskFactors
                                  ? "tap_to_view_detailed_information".tr
                                  : "tap_to_learn_about_pregnancy_risks".tr,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: NeoSafeColors.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: themeService.getPrimaryColor(),
                              size: 12,
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
        );
      },
    );
  }

  Widget _buildNoRiskFactorsContent(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeoSafeColors.success.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: NeoSafeColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sentiment_very_satisfied_rounded,
              color: NeoSafeColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Looking Good!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "No known risk factors identified at this stage.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: NeoSafeColors.secondaryText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFactorsPreview(BuildContext context, ThemeData theme) {
    final themeService = Get.find<ThemeService>();
    final previewCategories = riskFactorGroups.keys.take(2).toList();

    return Column(
      children: [
        ...previewCategories.map((category) {
          final factorCount = riskFactorGroups[category]!.length;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NeoSafeColors.creamWhite.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NeoSafeColors.warning.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        NeoSafeColors.warning,
                        NeoSafeColors.warning.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: NeoSafeColors.primaryText,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "$factorCount",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: NeoSafeColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (riskFactorGroups.length > 2)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeService.getPrimaryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+${riskFactorGroups.length - 2} more categories",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: themeService.getPrimaryColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRiskFactorsList(BuildContext context, ThemeData theme,
      Map<String, List<String>> userRiskFactors) {
    return Column(
      children: [
        ...userRiskFactors.entries.map((entry) {
          final category = entry.key;
          final factors = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NeoSafeColors.creamWhite.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NeoSafeColors.warning.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        NeoSafeColors.warning,
                        NeoSafeColors.warning.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: NeoSafeColors.primaryText,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${factors.length}",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: NeoSafeColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showBloodGroupBottomSheet(BuildContext context) {
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;

    // Check if all fields are already set
    final hasBabyBloodGroup =
        user?.babyBloodGroup != null && user!.babyBloodGroup!.isNotEmpty;
    final hasMotherBloodGroup =
        user?.motherBloodGroup != null && user!.motherBloodGroup!.isNotEmpty;
    final hasRelation = user?.relation != null && user!.relation!.isNotEmpty;

    // If all fields are set, navigate to risk factor view
    if (hasBabyBloodGroup && hasMotherBloodGroup && hasRelation) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RiskFactorView(),
        ),
      );
      return;
    }

    // Show bottom sheet with missing fields
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BloodGroupBottomSheet(
        currentBabyBloodGroup: user?.babyBloodGroup,
        currentMotherBloodGroup: user?.motherBloodGroup,
        currentRelation: user?.relation,
      ),
    );
  }
}

class BloodGroupBottomSheet extends StatefulWidget {
  final String? currentBabyBloodGroup;
  final String? currentMotherBloodGroup;
  final String? currentRelation;

  const BloodGroupBottomSheet({
    super.key,
    this.currentBabyBloodGroup,
    this.currentMotherBloodGroup,
    this.currentRelation,
  });

  @override
  State<BloodGroupBottomSheet> createState() => _BloodGroupBottomSheetState();
}

class _BloodGroupBottomSheetState extends State<BloodGroupBottomSheet> {
  final AuthService authService = Get.find<AuthService>();
  String? selectedBabyBloodGroup;
  String? selectedMotherBloodGroup;
  String? selectedRelation;
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final relations = [
    'Relative',
    'First Cousin',
    'Second Cousin',
    'No Relation'
  ];

  @override
  void initState() {
    super.initState();
    selectedBabyBloodGroup = widget.currentBabyBloodGroup;
    selectedMotherBloodGroup = widget.currentMotherBloodGroup;
    selectedRelation = widget.currentRelation;
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Container(
      decoration: const BoxDecoration(
        color: NeoSafeColors.creamWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeService.getPrimaryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bloodtype,
                      color: themeService.getPrimaryColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Complete Your Profile',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: NeoSafeColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide the following information to assess risk factors',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.secondaryText,
                    ),
              ),
              const SizedBox(height: 24),

              // Baby Blood Group
              if (widget.currentBabyBloodGroup == null ||
                  widget.currentBabyBloodGroup!.isEmpty)
                _buildDropdownField(
                  'Baby\'s Blood Group',
                  selectedBabyBloodGroup,
                  bloodGroups,
                  (value) => setState(() => selectedBabyBloodGroup = value),
                ),

              // Mother Blood Group
              if (widget.currentMotherBloodGroup == null ||
                  widget.currentMotherBloodGroup!.isEmpty)
                _buildDropdownField(
                  'Mother\'s Blood Group',
                  selectedMotherBloodGroup,
                  bloodGroups,
                  (value) => setState(() => selectedMotherBloodGroup = value),
                ),

              // Relation
              if (widget.currentRelation == null ||
                  widget.currentRelation!.isEmpty)
                _buildDropdownField(
                  'Relation',
                  selectedRelation,
                  relations,
                  (value) => setState(() => selectedRelation = value),
                ),

              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeService.getPrimaryColor(),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Save & Continue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    final themeService = Get.find<ThemeService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: NeoSafeColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: NeoSafeColors.lightBeige,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: NeoSafeColors.softGray.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            dropdownColor: NeoSafeColors.creamWhite,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: NeoSafeColors.primaryText,
                ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: themeService.getPrimaryColor(),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _saveData() async {
    final user = authService.currentUser.value;
    if (user != null) {
      final updatedUser = user.copyWith(
        babyBloodGroup: selectedBabyBloodGroup ?? user.babyBloodGroup,
        motherBloodGroup: selectedMotherBloodGroup ?? user.motherBloodGroup,
        relation: selectedRelation ?? user.relation,
      );

      await authService.saveCurrentUser(updatedUser);

      Navigator.of(context).pop();

      // Navigate to risk factor view after saving
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RiskFactorView(),
        ),
      );
    }
  }
}
