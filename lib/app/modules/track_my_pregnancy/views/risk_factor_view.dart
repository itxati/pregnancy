import 'package:flutter/material.dart';
import 'package:babysafe/app/data/const/risk_factor.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class RiskFactorView extends StatelessWidget {
  const RiskFactorView({super.key});

  // Icon mapping for different risk factor categories
  final Map<String, IconData> categoryIcons = const {
    "Medical History": Icons.medical_information_rounded,
    "Lifestyle": Icons.health_and_safety_rounded,
    "Environmental": Icons.eco_rounded,
    "Genetic": Icons.biotech_rounded,
    "Age Related": Icons.schedule_rounded,
    "Nutritional": Icons.restaurant_rounded,
    "Physical": Icons.fitness_center_rounded,
    "Emotional": Icons.psychology_rounded,
    "First Cousin Marriage": Icons.biotech_rounded,
    "Second Cousin Marriage": Icons.biotech_rounded,
    "Relative Marriage": Icons.family_restroom_rounded,
    "No Relation": Icons.people_rounded,
  };

  IconData _getIconForCategory(String category) {
    // Try exact match first
    if (categoryIcons.containsKey(category)) {
      return categoryIcons[category]!;
    }

    // Try partial matches
    for (var key in categoryIcons.keys) {
      if (category.toLowerCase().contains(key.toLowerCase()) ||
          key.toLowerCase().contains(category.toLowerCase())) {
        return categoryIcons[key]!;
      }
    }

    // Default icon
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: NeoSafeColors.warmWhite,
      appBar: AppBar(
        title: Text(
          'Risk Factors',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NeoSafeColors.primaryPink,
                NeoSafeColors.roseAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              NeoSafeColors.warmWhite,
              NeoSafeColors.lightBeige.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: riskFactorGroups.isEmpty
            ? _buildEmptyState(context, theme)
            : _buildRiskFactorsList(context, theme),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              NeoSafeColors.creamWhite,
              NeoSafeColors.palePink.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: NeoSafeColors.success.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.success.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    NeoSafeColors.success.withOpacity(0.9),
                    NeoSafeColors.success.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: NeoSafeColors.success.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.health_and_safety_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Great News!",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: NeoSafeColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No known risk factors identified for your current pregnancy stage.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: NeoSafeColors.secondaryText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskFactorsList(BuildContext context, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header card
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NeoSafeColors.warning.withOpacity(0.1),
                NeoSafeColors.palePink.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NeoSafeColors.warning.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoSafeColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: NeoSafeColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Risk Awareness",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: NeoSafeColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Understanding these factors helps ensure a healthier pregnancy journey.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: NeoSafeColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Risk factor categories
        ...riskFactorGroups.entries.map((entry) {
          final categoryIcon = _getIconForCategory(entry.key);

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.creamWhite,
                  NeoSafeColors.palePink.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NeoSafeColors.primaryPink.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.primaryPink.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        NeoSafeColors.primaryPink.withOpacity(0.1),
                        NeoSafeColors.roseAccent.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              NeoSafeColors.primaryPink.withOpacity(0.9),
                              NeoSafeColors.roseAccent.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: NeoSafeColors.primaryPink.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          categoryIcon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: NeoSafeColors.primaryText,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoSafeColors.primaryPink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${entry.value.length}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: NeoSafeColors.primaryPink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Risk factor items
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: entry.value.map((point) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: NeoSafeColors.primaryPink.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    NeoSafeColors.primaryPink,
                                    NeoSafeColors.roseAccent,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                point,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: NeoSafeColors.primaryText,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
