import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/risk_assessment_controller.dart';

class RiskAssessmentCard extends StatefulWidget {
  final RiskAssessmentController controller;

  const RiskAssessmentCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<RiskAssessmentCard> createState() => _RiskAssessmentCardState();
}

class _RiskAssessmentCardState extends State<RiskAssessmentCard> {
  bool _isDownSyndromeExpanded = false;
  bool _isGDMExpanded = false;
  bool _isIUGRSGAExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.1),
                  Colors.purple.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assessment,
                  color: Colors.purple[700],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'pregnancy_risk_assessment'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'down_syndrome_gdm_iugr_sga'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      Icon(Icons.settings_outlined, color: Colors.purple[700]),
                  onPressed: () =>
                      _showRiskFactorsDialog(context, widget.controller),
                  tooltip: 'risk_factors'.tr,
                ),
              ],
            ),
          ),

          // Down Syndrome Risk - Expandable section
          Obx(() => widget.controller.downSyndromeRisk.value != null
              ? _buildExpandableDownSyndromeSection(
                  widget.controller.downSyndromeRisk.value!)
              : const SizedBox.shrink()),

          // GDM Risk - Expandable section
          Obx(() => widget.controller.gdmRisk.value != null
              ? _buildExpandableGDMSection(widget.controller.gdmRisk.value!)
              : const SizedBox.shrink()),

          // IUGR/SGA Risk - Expandable section
          Obx(() => widget.controller.iugrSgaRisk.value != null
              ? _buildExpandableIUGRSGASection(
                  widget.controller.iugrSgaRisk.value!)
              : const SizedBox.shrink()),

          // Educational Footer
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'about_risk_assessment'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'risk_assessment_description'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.blue[800],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: Text(
                    'common_risk_factors'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'risk_factors_affect_pregnancy_outcomes'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRiskFactorItem('maternal_hypertension'.tr),
                          _buildRiskFactorItem('preeclampsia'.tr),
                          _buildRiskFactorItem('placental_insufficiency'.tr),
                          _buildRiskFactorItem('infections'.tr),
                          _buildRiskFactorItem('smoking_substance_use'.tr),
                          _buildRiskFactorItem('chronic_diseases'.tr),
                          _buildRiskFactorItem('multiple_gestation'.tr),
                          _buildRiskFactorItem('poor_maternal_nutrition'.tr),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableDownSyndromeSection(dynamic risk) {
    if (risk == null) return const SizedBox.shrink();

    Color riskColor;
    if (risk.riskCategory == 'High') {
      riskColor = Colors.red;
    } else if (risk.riskCategory == 'Intermediate') {
      riskColor = Colors.orange;
    } else if (risk.riskCategory == 'Unknown') {
      riskColor = Colors.grey;
    } else {
      riskColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header with title and dropdown button
          InkWell(
            onTap: () {
              setState(() {
                _isDownSyndromeExpanded = !_isDownSyndromeExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.analytics, color: riskColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'down_syndrome_risk'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isDownSyndromeExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: riskColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          if (_isDownSyndromeExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildDownSyndromeContent(risk, riskColor),
            ),
        ],
      ),
    );
  }

  Widget _buildDownSyndromeContent(dynamic risk, Color riskColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          risk.riskCategory == 'Unknown'
              ? 'age_required_calculate_risk'.tr
              : '${'risk_colon'.tr} 1 ${'in'.tr} ${risk.riskValue.toStringAsFixed(0)} (${risk.riskCategory} ${'risk'.tr})',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: riskColor,
          ),
        ),
        if (risk.riskCategory == 'Unknown') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'enter_age_risk_factors_settings'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          risk.explanation,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'understanding_risk_assessment'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'risk_assessment_explanation'.tr,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.blue[800],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ExpansionTile(
          title: Text(
            'screening_options_non_invasive'.tr,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'screening_tests_description'.tr,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...risk.screeningOptions
                .map((option) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              option,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          title: Text(
            'diagnostic_options_invasive'.tr,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.red[700],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'diagnostic_tests_description'.tr,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.red[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...risk.diagnosticOptions
                .map((option) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 16, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              option,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildDownSyndromeSection(dynamic risk) {
    if (risk == null) return const SizedBox.shrink();

    Color riskColor;
    if (risk.riskCategory == 'High') {
      riskColor = Colors.red;
    } else if (risk.riskCategory == 'Intermediate') {
      riskColor = Colors.orange;
    } else if (risk.riskCategory == 'Unknown') {
      riskColor = Colors.grey;
    } else {
      riskColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: riskColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'down_syndrome_risk'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            risk.riskCategory == 'Unknown'
                ? 'age_required_calculate_risk'.tr
                : '${'risk_colon'.tr} 1 ${'in'.tr} ${risk.riskValue.toStringAsFixed(0)} (${risk.riskCategory} ${'risk'.tr})',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: riskColor,
            ),
          ),
          if (risk.riskCategory == 'Unknown') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'enter_age_risk_factors_settings'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.amber[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            risk.explanation,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Text(
                      'understanding_risk_assessment'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'risk_assessment_explanation'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.blue[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            title: Text(
              'screening_options_non_invasive'.tr,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'screening_tests_description'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ...risk.screeningOptions
                  .map((option) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                option,
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            title: Text(
              'diagnostic_options_invasive'.tr,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'diagnostic_tests_description'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.red[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ...risk.diagnosticOptions
                  .map((option) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                option,
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableGDMSection(dynamic risk) {
    Color riskColor;
    if (risk.riskLevel == 'High') {
      riskColor = Colors.red;
    } else if (risk.riskLevel == 'Moderate') {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header with title and dropdown button
          InkWell(
            onTap: () {
              setState(() {
                _isGDMExpanded = !_isGDMExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.bloodtype, color: riskColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'gdm_risk_assessment'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isGDMExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: riskColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          if (_isGDMExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildGDMContent(risk, riskColor),
            ),
        ],
      ),
    );
  }

  Widget _buildGDMContent(dynamic risk, Color riskColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          '${'risk_level_colon'.tr} ${risk.riskLevel}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: riskColor,
          ),
        ),
        const SizedBox(height: 8),
        if (risk.riskFactors.isNotEmpty) ...[
          Text(
            'risk_factors_colon'.tr,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          ...risk.riskFactors.map((factor) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 6, color: riskColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        factor,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'screening_recommendation'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                risk.screeningRecommendation,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 12),
              ExpansionTile(
                title: Text(
                  'about_gdm_screening'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'gdm_risk_title'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'gdm_risk_description'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.blue[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'screening_guidelines'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'screening_guidelines_description'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.blue[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGDMSection(dynamic risk) {
    Color riskColor;
    if (risk.riskLevel == 'High') {
      riskColor = Colors.red;
    } else if (risk.riskLevel == 'Moderate') {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bloodtype, color: riskColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'gdm_risk_assessment'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${'risk_level_colon'.tr} ${risk.riskLevel}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: riskColor,
            ),
          ),
          const SizedBox(height: 8),
          if (risk.riskFactors.isNotEmpty) ...[
            Text(
              'risk_factors_colon'.tr,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            ...risk.riskFactors.map((factor) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.circle, size: 6, color: riskColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          factor,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Text(
                      'screening_recommendation'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  risk.screeningRecommendation,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: Text(
                    'about_gdm_screening'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'gdm_risk_title'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'gdm_risk_description'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.blue[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'screening_guidelines'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'screening_guidelines_description'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.blue[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableIUGRSGASection(dynamic risk) {
    if (risk == null) return const SizedBox.shrink();

    Color riskColor;
    if (risk.riskLevel == 'High') {
      riskColor = Colors.red;
    } else if (risk.riskLevel == 'Moderate') {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header with title and dropdown button
          InkWell(
            onTap: () {
              setState(() {
                _isIUGRSGAExpanded = !_isIUGRSGAExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.child_care, color: riskColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'iugr_sga_risk_assessment'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isIUGRSGAExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: riskColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          if (_isIUGRSGAExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildIUGRSGAContent(risk, riskColor),
            ),
        ],
      ),
    );
  }

  Widget _buildIUGRSGAContent(dynamic risk, Color riskColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (risk.isIUGR || risk.isSGA) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  risk.isIUGR ? Icons.warning : Icons.info_outline,
                  color: riskColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    risk.isIUGR
                        ? 'iugr_detected_message'.tr
                        : 'sga_detected_message'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: riskColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          '${'risk_level_colon'.tr} ${risk.riskLevel}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: riskColor,
          ),
        ),
        if (risk.estimatedFetalWeight != null &&
            risk.estimatedFetalWeight! > 0) ...[
          const SizedBox(height: 8),
          Text(
            '${'estimated_fetal_weight_colon'.tr} ${(risk.estimatedFetalWeight! / 1000).toStringAsFixed(2)} ${'kg_unit'.tr}',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
          ),
          Text(
            '${'percentile_colon'.tr} ${risk.percentile}th',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
          ),
        ] else if (risk.estimatedFetalWeight == null ||
            risk.estimatedFetalWeight == 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'no_ultrasound_data_message'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (risk.riskFactors.isNotEmpty) ...[
          Text(
            'risk_factors_colon'.tr,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          ...risk.riskFactors.map((factor) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 6, color: riskColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        factor,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medical_services,
                      size: 16, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Text(
                    'recommendation'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                risk.recommendation,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.orange[800],
                ),
              ),
              const SizedBox(height: 12),
              ExpansionTile(
                title: Text(
                  'understanding_iugr_sga'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'what_is_iugr_sga'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'iugr_sga_definition'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.orange[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'why_it_matters'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'iugr_sga_why_matters'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.orange[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'how_its_detected'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'iugr_sga_detection'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.orange[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'management_principles'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'iugr_sga_management'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.orange[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIUGRSGASection(dynamic risk) {
    if (risk == null) return const SizedBox.shrink();

    Color riskColor;
    if (risk.riskLevel == 'High') {
      riskColor = Colors.red;
    } else if (risk.riskLevel == 'Moderate') {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.child_care, color: riskColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'iugr_sga_risk_assessment'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (risk.isIUGR || risk.isSGA) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    risk.isIUGR ? Icons.warning : Icons.info_outline,
                    color: riskColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      risk.isIUGR
                          ? 'iugr_detected_message'.tr
                          : 'sga_detected_message'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: riskColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            '${'risk_level_colon'.tr} ${risk.riskLevel}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: riskColor,
            ),
          ),
          if (risk.estimatedFetalWeight != null &&
              risk.estimatedFetalWeight! > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${'estimated_fetal_weight_colon'.tr} ${(risk.estimatedFetalWeight! / 1000).toStringAsFixed(2)} ${'kg_unit'.tr}',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
            ),
            Text(
              '${'percentile_colon'.tr} ${risk.percentile}th',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
            ),
          ] else if (risk.estimatedFetalWeight == null ||
              risk.estimatedFetalWeight == 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'no_ultrasound_data_message'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (risk.riskFactors.isNotEmpty) ...[
            Text(
              'risk_factors_colon'.tr,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            ...risk.riskFactors.map((factor) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.circle, size: 6, color: riskColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          factor,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services,
                        size: 16, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Text(
                      'recommendation'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  risk.recommendation,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: Text(
                    'understanding_iugr_sga'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'what_is_iugr_sga'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'iugr_sga_definition'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'why_it_matters'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'iugr_sga_why_matters'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'how_its_detected'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'iugr_sga_detection'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'management_principles'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'iugr_sga_management'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRiskFactorsDialog(
      BuildContext context, RiskAssessmentController controller) {
    // Safety check before showing dialog
    if (!Get.isRegistered<RiskAssessmentController>() &&
        controller.runtimeType != RiskAssessmentController) {
      Get.snackbar('error'.tr, 'risk_assessment_controller_not_available'.tr);
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'risk_factors'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Column(
                      children: [
                        SwitchListTile(
                          title: Text('family_history_diabetes'.tr),
                          value: controller.hasFamilyHistoryGDM.value,
                          onChanged: (v) {
                            controller.hasFamilyHistoryGDM.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('previous_gdm'.tr),
                          value: controller.hasPreviousGDM.value,
                          onChanged: (v) {
                            controller.hasPreviousGDM.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('hypertension'.tr),
                          value: controller.hasHypertension.value,
                          onChanged: (v) {
                            controller.hasHypertension.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('preeclampsia'.tr),
                          value: controller.hasPreeclampsia.value,
                          onChanged: (v) {
                            controller.hasPreeclampsia.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('smoking'.tr),
                          value: controller.isSmoking.value,
                          onChanged: (v) {
                            controller.isSmoking.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('chronic_diseases'.tr),
                          value: controller.hasChronicDisease.value,
                          onChanged: (v) {
                            controller.hasChronicDisease.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('multiple_gestation'.tr),
                          value: controller.isMultipleGestation.value,
                          onChanged: (v) {
                            controller.isMultipleGestation.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ethnicity'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: controller.ethnicity.value.isEmpty
                              ? null
                              : controller.ethnicity.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: [
                            'ethnicity_asian'.tr,
                            'ethnicity_hispanic'.tr,
                            'ethnicity_african'.tr,
                            'ethnicity_caucasian'.tr,
                            'ethnicity_native_american'.tr,
                            'ethnicity_other'.tr
                          ]
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              controller.ethnicity.value = v;
                              controller.saveRiskFactors();
                            }
                          },
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('close'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiskFactorItem(String factor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              factor,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
