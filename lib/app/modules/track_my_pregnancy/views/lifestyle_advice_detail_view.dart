import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';

class LifestyleAdviceDetailView extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const LifestyleAdviceDetailView({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
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
                          color:
                              themeService.getPrimaryColor().withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                themeService.getPrimaryColor().withOpacity(0.1),
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
                                  themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.9),
                                  themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.3),
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
      case "Nutrition":
        return _getNutritionContent();
      case "Exercise":
        return _getExerciseContent();
      case "Hygiene":
        return _getHygieneContent();
      case "Sleep":
        return _getSleepContent();
      default:
        return _getDefaultContent();
    }
  }

  List<Widget> _getNutritionContent() {
    return [
      _buildSectionCard(
        "Essential Nutrients During Pregnancy",
        [
          "Folic Acid: 400-800 mcg daily to prevent birth defects",
          "Iron: 27 mg daily to support increased blood volume",
          "Calcium: 1000 mg daily for baby's bone development",
          "Protein: 75-100g daily for fetal growth",
          "Omega-3 DHA: 200-300 mg daily for brain development",
          "Vitamin D: 600 IU daily for bone health",
        ],
      ),
      _buildSectionCard(
        "Foods to Include",
        [
          "Leafy green vegetables (spinach, kale, broccoli)",
          "Lean proteins (chicken, fish, beans, lentils)",
          "Whole grains (brown rice, quinoa, oats)",
          "Dairy products (milk, yogurt, cheese)",
          "Fresh fruits and vegetables",
          "Nuts and seeds (almonds, walnuts, chia seeds)",
        ],
      ),
      _buildSectionCard(
        "Foods to Avoid",
        [
          "Raw or undercooked meat and fish",
          "Unpasteurized dairy products",
          "High-mercury fish (shark, swordfish, king mackerel)",
          "Excessive caffeine (limit to 200mg daily)",
          "Alcohol and tobacco",
          "Raw eggs and deli meats",
        ],
      ),
      _buildSectionCard(
        "Hydration Tips",
        [
          "Drink 8-10 glasses of water daily",
          "Carry a water bottle with you",
          "Add lemon or cucumber for flavor",
          "Monitor urine color (should be pale yellow)",
          "Increase intake during hot weather or exercise",
          "Limit sugary drinks and sodas",
        ],
      ),
    ];
  }

  List<Widget> _getExerciseContent() {
    return [
      _buildSectionCard(
        "Safe Exercises During Pregnancy",
        [
          "Walking: 30 minutes daily at moderate pace",
          "Swimming: Low-impact, full-body workout",
          "Prenatal yoga: Improves flexibility and relaxation",
          "Stationary cycling: Safe cardiovascular exercise",
          "Pilates: Strengthens core and improves posture",
          "Light strength training with proper form",
        ],
      ),
      _buildSectionCard(
        "Benefits of Exercise",
        [
          "Reduces back pain and improves posture",
          "Helps with sleep and mood regulation",
          "Prepares body for labor and delivery",
          "Reduces risk of gestational diabetes",
          "Maintains healthy weight gain",
          "Increases energy levels",
        ],
      ),
      _buildSectionCard(
        "Exercise Safety Guidelines",
        [
          "Always consult your healthcare provider first",
          "Stop if you feel dizzy, short of breath, or pain",
          "Avoid exercises lying flat on your back after 16 weeks",
          "Stay hydrated and avoid overheating",
          "Wear supportive, comfortable clothing",
          "Listen to your body and rest when needed",
        ],
      ),
      _buildSectionCard(
        "Exercises to Avoid",
        [
          "High-impact activities (running, jumping)",
          "Contact sports and activities with fall risk",
          "Exercises that require lying on your back",
          "Hot yoga or exercise in extreme heat",
          "Heavy lifting or straining",
          "Activities with sudden direction changes",
        ],
      ),
    ];
  }

  List<Widget> _getHygieneContent() {
    return [
      _buildSectionCard(
        "Daily Hygiene Routine",
        [
          "Shower or bathe daily with mild, fragrance-free soap",
          "Wash hands frequently, especially before eating",
          "Brush teeth twice daily with fluoride toothpaste",
          "Floss daily to prevent gum disease",
          "Keep nails clean and trimmed",
          "Change underwear and clothes daily",
        ],
      ),
      _buildSectionCard(
        "Skin Care During Pregnancy",
        [
          "Use gentle, pregnancy-safe skincare products",
          "Apply sunscreen daily to prevent melasma",
          "Moisturize regularly to prevent stretch marks",
          "Avoid harsh chemicals and retinoids",
          "Keep skin clean and dry to prevent infections",
          "Consult dermatologist for skin concerns",
        ],
      ),
      _buildSectionCard(
        "Oral Health",
        [
          "Schedule regular dental checkups",
          "Inform dentist about your pregnancy",
          "Use soft-bristled toothbrush",
          "Rinse with fluoride mouthwash",
          "Eat calcium-rich foods for strong teeth",
          "Avoid sugary snacks and drinks",
        ],
      ),
      _buildSectionCard(
        "Personal Care Products",
        [
          "Choose fragrance-free and hypoallergenic products",
          "Avoid products with harsh chemicals",
          "Use pregnancy-safe deodorants and antiperspirants",
          "Select gentle, sulfate-free shampoos",
          "Read labels and avoid harmful ingredients",
          "Consider natural and organic alternatives",
        ],
      ),
    ];
  }

  List<Widget> _getSleepContent() {
    return [
      _buildSectionCard(
        "Sleep Position Recommendations",
        [
          "Sleep on your left side for optimal blood flow",
          "Use pregnancy pillows for support and comfort",
          "Avoid sleeping on your back after 20 weeks",
          "Place pillow between knees for hip support",
          "Elevate upper body if experiencing heartburn",
          "Find comfortable positions that work for you",
        ],
      ),
      _buildSectionCard(
        "Creating a Sleep-Friendly Environment",
        [
          "Keep bedroom cool, dark, and quiet",
          "Use blackout curtains or eye mask",
          "Invest in comfortable mattress and pillows",
          "Remove electronic devices from bedroom",
          "Use white noise machine if needed",
          "Keep room well-ventilated",
        ],
      ),
      _buildSectionCard(
        "Sleep Hygiene Tips",
        [
          "Maintain consistent sleep schedule",
          "Avoid large meals and caffeine before bed",
          "Limit screen time 1 hour before sleep",
          "Practice relaxation techniques",
          "Take warm bath or shower before bed",
          "Create bedtime routine to signal sleep time",
        ],
      ),
      _buildSectionCard(
        "Managing Sleep Disruptions",
        [
          "Frequent urination: Limit fluids before bed",
          "Heartburn: Eat smaller meals, avoid spicy foods",
          "Leg cramps: Stretch before bed, stay hydrated",
          "Anxiety: Practice meditation or deep breathing",
          "Restless legs: Gentle massage and warm bath",
          "Snoring: Use nasal strips or humidifier",
        ],
      ),
      _buildSectionCard(
        "When to Seek Help",
        [
          "Persistent insomnia affecting daily function",
          "Severe sleep apnea or breathing problems",
          "Excessive daytime sleepiness",
          "Sleep disturbances due to anxiety or depression",
          "Physical pain preventing sleep",
          "Any concerns about sleep quality",
        ],
      ),
    ];
  }

  List<Widget> _getDefaultContent() {
    return [
      _buildSectionCard(
        "General Lifestyle Tips",
        [
          "Maintain regular prenatal care appointments",
          "Follow your healthcare provider's recommendations",
          "Listen to your body and rest when needed",
          "Stay informed about pregnancy changes",
          "Connect with other expectant mothers",
          "Prepare for your baby's arrival",
        ],
      ),
    ];
  }

  Widget _buildSectionCard(String title, List<String> items) {
    final themeService = Get.find<ThemeService>();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeService.getPrimaryColor().withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.05),
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
                        color: themeService.getPrimaryColor(),
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
}
