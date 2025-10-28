import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BirthPreparednessDetailView extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const BirthPreparednessDetailView({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeService.getPaleColor().withOpacity(0.3),
              themeService.getPaleColor().withOpacity(0.8),
              themeService.getBabyColor().withOpacity(0.6),
              themeService.getLightColor().withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: themeService.getPrimaryColor(),
                ),
                onPressed: () => Get.back(),
              ),
              // flexibleSpace: FlexibleSpaceBar(
              //   title: Text(
              //     title,
              //     style: TextStyle(
              //       color: NeoSafeColors.primaryText,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              //   background: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [
              //           themeService.getPaleColor().withOpacity(0.1),
              //           themeService.getLightColor().withOpacity(0.05),
              //         ],
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //       ),
              //     ),
              //   ),
              // ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getLightColor().withOpacity(0.1),
                            themeService.getPaleColor().withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  accentColor.withOpacity(0.9),
                                  accentColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: NeoSafeColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Detailed Content
                    ..._getDetailedContent(title),
                    const SizedBox(height: 30),
                    // Action Button for Transport Plan
                    if (title == "transport_plan".tr) ...[
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              NeoSafeColors.error.withOpacity(0.9),
                              NeoSafeColors.error.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: NeoSafeColors.error.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _callAmbulance(),
                          icon: const Icon(Icons.phone,
                              color: Colors.white, size: 24),
                          label: Text(
                            "Call Ambulance (1034)",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDetailedContent(String title) {
    switch (title) {
      case "labor_signs":
        return _getLaborSignsContent();
      case "delivery_mode":
        return _getDeliveryModeContent();
      case "hospital_bag":
        return _getHospitalBagContent();
      case "transport_plan":
        return _getTransportPlanContent();
      case "breastfeeding":
        return _getBreastfeedingContent();
      default:
        return _getDefaultContent();
    }
  }

  List<Widget> _getLaborSignsContent() {
    return [
      _buildSectionCard(
        "Early Labor Signs",
        [
          "Regular contractions that get stronger and closer together",
          "Lower back pain or cramping",
          "Water breaking (amniotic fluid)",
          "Bloody show (mucus plug)",
          "Nesting instinct or energy burst",
        ],
      ),
      _buildSectionCard(
        "When to Call Your Doctor",
        [
          "Contractions every 5 minutes for 1 hour",
          "Water breaks (even without contractions)",
          "Heavy bleeding",
          "Severe headache or vision changes",
          "Decreased fetal movement",
        ],
      ),
      _buildSectionCard(
        "What to Do During Early Labor",
        [
          "Stay calm and time contractions",
          "Eat light snacks and stay hydrated",
          "Take a warm shower or bath",
          "Practice breathing techniques",
          "Pack your hospital bag if not done",
        ],
      ),
    ];
  }

  List<Widget> _getDeliveryModeContent() {
    return [
      _buildSectionCard(
        "Vaginal Delivery",
        [
          "Most common and natural delivery method",
          "Faster recovery time",
          "Lower risk of complications",
          "Can use pain management options",
          "Vaginal birth after cesarean (VBAC) may be possible",
        ],
      ),
      _buildSectionCard(
        "Cesarean Section (C-Section)",
        [
          "Surgical delivery through abdominal incision",
          "May be planned or emergency procedure",
          "Longer recovery time (6-8 weeks)",
          "Higher risk of complications",
          "May be necessary for medical reasons",
        ],
      ),
      _buildSectionCard(
        "Pain Management Options",
        [
          "Epidural anesthesia",
          "Natural pain relief techniques",
          "Nitrous oxide (laughing gas)",
          "Water birth",
          "Breathing and relaxation techniques",
        ],
      ),
    ];
  }

  List<Widget> _getHospitalBagContent() {
    return [
      _buildSectionCard(
        "For Mom",
        [
          "Comfortable nightgowns or pajamas",
          "Nursing bras and breast pads",
          "Underwear and maternity pads",
          "Toiletries and personal items",
          "Comfortable going-home outfit",
          "Phone charger and camera",
        ],
      ),
      _buildSectionCard(
        "For Baby",
        [
          "Newborn diapers and wipes",
          "Going-home outfit (2-3 options)",
          "Baby blanket and hat",
          "Car seat (required for discharge)",
          "Baby nail clippers",
          "Pacifiers (optional)",
        ],
      ),
      _buildSectionCard(
        "Important Documents",
        [
          "Insurance cards and ID",
          "Birth plan and medical records",
          "Hospital pre-registration forms",
          "Emergency contact list",
          "Camera or phone for photos",
        ],
      ),
    ];
  }

  List<Widget> _getTransportPlanContent() {
    return [
      _buildSectionCard(
        "Emergency Contacts",
        [
          "Ambulance: 1034 (Emergency)",
          "Your doctor's emergency number",
          "Hospital labor and delivery unit",
          "Partner or support person",
          "Backup transportation contact",
        ],
      ),
      _buildSectionCard(
        "Transportation Options",
        [
          "Ambulance for emergencies",
          "Pre-arranged ride with family/friend",
          "Ride-sharing service (Uber/Lyft)",
          "Your own vehicle (if not in labor)",
          "Public transportation (if early labor)",
        ],
      ),
      _buildSectionCard(
        "What to Do in Emergency",
        [
          "Call 1034 immediately",
          "Stay calm and follow instructions",
          "Have someone stay with you",
          "Grab your hospital bag",
          "Time contractions if possible",
        ],
      ),
    ];
  }

  List<Widget> _getBreastfeedingContent() {
    return [
      _buildSectionCard(
        "Benefits of Breastfeeding",
        [
          "Perfect nutrition for your baby",
          "Boosts immune system",
          "Bonds with your baby",
          "Helps with postpartum recovery",
          "Cost-effective and convenient",
        ],
      ),
      _buildSectionCard(
        "Getting Started",
        [
          "Start within first hour after birth",
          "Skin-to-skin contact immediately",
          "Feed on demand (8-12 times per day)",
          "Learn proper latch technique",
          "Stay hydrated and well-nourished",
        ],
      ),
      _buildSectionCard(
        "Common Challenges",
        [
          "Sore or cracked nipples",
          "Low milk supply concerns",
          "Baby not latching properly",
          "Engorgement and blocked ducts",
          "Getting enough sleep",
        ],
      ),
      _buildSectionCard(
        "Support Resources",
        [
          "Lactation consultant",
          "Breastfeeding support groups",
          "Online resources and apps",
          "Family and partner support",
          "Healthcare provider guidance",
        ],
      ),
    ];
  }

  List<Widget> _getDefaultContent() {
    return [
      _buildSectionCard(
        "Important Information",
        [
          "Consult with your healthcare provider",
          "Follow your birth plan",
          "Stay informed and prepared",
          "Trust your instincts",
          "Ask questions when in doubt",
        ],
      ),
    ];
  }

  Widget _buildSectionCard(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: NeoSafeColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _callAmbulance() async {
    const phoneNumber = 'tel:1034';
    final Uri phoneUri = Uri.parse(phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Get.snackbar(
          'Error',
          'Could not open phone dialer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: NeoSafeColors.error.withOpacity(0.1),
          colorText: NeoSafeColors.error,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to make phone call: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.error.withOpacity(0.1),
        colorText: NeoSafeColors.error,
      );
    }
  }
}
