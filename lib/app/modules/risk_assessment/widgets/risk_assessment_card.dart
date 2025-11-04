import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/risk_assessment_controller.dart';

class RiskAssessmentCard extends StatelessWidget {
  final RiskAssessmentController controller;

  const RiskAssessmentCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

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
                        'Pregnancy Risk Assessment',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Down Syndrome • GDM • IUGR/SGA',
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
                  onPressed: () => _showRiskFactorsDialog(context),
                  tooltip: 'Risk Factors',
                ),
              ],
            ),
          ),

          // Down Syndrome Risk - Always show (will prompt for age if needed)
          Obx(() => controller.downSyndromeRisk.value != null
              ? _buildDownSyndromeSection(controller.downSyndromeRisk.value!)
              : const SizedBox.shrink()),

          // GDM Risk - Always calculated
          Obx(() => controller.gdmRisk.value != null
              ? _buildGDMSection(controller.gdmRisk.value!)
              : const SizedBox.shrink()),

          // IUGR/SGA Risk - Always show (based on risk factors even without ultrasound)
          Obx(() => controller.iugrSgaRisk.value != null
              ? _buildIUGRSGASection(controller.iugrSgaRisk.value!)
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
                      'About Risk Assessment',
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
                  'Risk assessments are estimates based on available information. They help guide screening and monitoring decisions. Always consult your healthcare provider for personalized medical advice.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.blue[800],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: Text(
                    'Common Risk Factors',
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
                            'Risk factors that may affect pregnancy outcomes include:',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRiskFactorItem('Maternal hypertension'),
                          _buildRiskFactorItem('Preeclampsia'),
                          _buildRiskFactorItem('Placental insufficiency'),
                          _buildRiskFactorItem('Infections'),
                          _buildRiskFactorItem('Smoking and substance use'),
                          _buildRiskFactorItem('Chronic diseases'),
                          _buildRiskFactorItem('Multiple gestation'),
                          _buildRiskFactorItem('Poor maternal nutrition'),
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
                'Down Syndrome Risk',
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
                ? 'Age Required to Calculate Risk'
                : 'Risk: 1 in ${risk.riskValue.toStringAsFixed(0)} (${risk.riskCategory} Risk)',
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
                      'Please enter your age in Risk Factors settings to calculate your Down syndrome risk.',
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
                      'Understanding Risk Assessment',
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
                  'Risk varies by maternal age and other factors. Screening tests assess risk and provide estimates, not diagnoses. Screening helps identify those who may benefit from diagnostic testing.',
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
              'Screening Options (Non-invasive)',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Screening tests assess risk but do not provide a diagnosis. They are non-invasive and help identify pregnancies that may benefit from diagnostic testing.',
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
              'Diagnostic Options (Invasive)',
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
                  'Diagnostic tests can provide a definitive diagnosis but are invasive procedures with a small risk of complications. They are typically recommended when screening indicates elevated risk.',
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
                'GDM Risk Assessment',
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
            'Risk Level: ${risk.riskLevel}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: riskColor,
            ),
          ),
          const SizedBox(height: 8),
          if (risk.riskFactors.isNotEmpty) ...[
            Text(
              'Risk Factors:',
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
                      'Screening Recommendation',
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
                    'About GDM Screening',
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
                            'Gestational Diabetes Mellitus (GDM) Risk:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'GDM risk is high when risk factors exist such as obesity, advanced maternal age, family history of diabetes, previous GDM, or certain ethnic backgrounds (Asian, Hispanic, African, Native American).',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.blue[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Screening Guidelines:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Universal or risk-based screening occurs in many guidelines. Standard screening typically happens at 24-28 weeks with a glucose tolerance test. Early screening (16-20 weeks) may be recommended if multiple high-risk factors are present.',
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
                'IUGR/SGA Risk Assessment',
                style: GoogleFonts.poppins(
                  fontSize: 14,
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
                          ? 'IUGR Detected - Fetus not reaching growth potential'
                          : 'SGA Detected - Baby smaller than typical',
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
            'Risk Level: ${risk.riskLevel}',
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
              'Estimated Fetal Weight: ${(risk.estimatedFetalWeight! / 1000).toStringAsFixed(2)} kg',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
            ),
            Text(
              'Percentile: ${risk.percentile}th',
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
                      'No ultrasound data available. Risk assessment is based on risk factors. Add ultrasound measurements for more accurate assessment.',
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
              'Risk Factors:',
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
                      'Recommendation',
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
                    'Understanding IUGR & SGA',
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
                            'What is IUGR/SGA?',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• IUGR (Intrauterine Growth Restriction): Refers to a fetus not reaching its growth potential, usually defined by estimated fetal weight below the 10th percentile for gestational age.\n\n'
                            '• SGA (Small-for-Gestational-Age): Means a baby is smaller than typical for gestational age but can be constitutionally small with normal health.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Why it matters:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Increased risk of stillbirth, perinatal distress, and later-onset health issues.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'How it\'s detected:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Regular fundal height measurements, ultrasound estimated fetal weight (EFW), Doppler studies, and growth velocity tracking.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Management principles:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Increased surveillance, timely delivery planning if there are signs of distress or abnormal Dopplers. Decision on expectant vs early delivery based on gestational age and fetal status.',
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

  void _showRiskFactorsDialog(BuildContext context) {
    // Safety check before showing dialog
    if (!Get.isRegistered<RiskAssessmentController>() &&
        controller.runtimeType != RiskAssessmentController) {
      Get.snackbar('Error', 'Risk assessment controller not available');
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
                  'Risk Factors',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Column(
                      children: [
                        SwitchListTile(
                          title: Text('Family History of Diabetes'),
                          value: controller.hasFamilyHistoryGDM.value,
                          onChanged: (v) {
                            controller.hasFamilyHistoryGDM.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('Previous GDM'),
                          value: controller.hasPreviousGDM.value,
                          onChanged: (v) {
                            controller.hasPreviousGDM.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('Hypertension'),
                          value: controller.hasHypertension.value,
                          onChanged: (v) {
                            controller.hasHypertension.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('Preeclampsia'),
                          value: controller.hasPreeclampsia.value,
                          onChanged: (v) {
                            controller.hasPreeclampsia.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('Smoking'),
                          value: controller.isSmoking.value,
                          onChanged: (v) {
                            controller.isSmoking.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('Chronic Diseases'),
                          value: controller.hasChronicDisease.value,
                          onChanged: (v) {
                            controller.hasChronicDisease.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        SwitchListTile(
                          title: Text('Multiple Gestation'),
                          value: controller.isMultipleGestation.value,
                          onChanged: (v) {
                            controller.isMultipleGestation.value = v;
                            controller.saveRiskFactors();
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ethnicity',
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
                            'Asian',
                            'Hispanic',
                            'African',
                            'Caucasian',
                            'Native American',
                            'Other'
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
                      child: Text('Close'),
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
