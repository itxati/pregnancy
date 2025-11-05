import 'package:flutter/material.dart';

class NutritionCard extends StatefulWidget {
  const NutritionCard({Key? key}) : super(key: key);

  @override
  State<NutritionCard> createState() => _NutritionCardState();
}

class _NutritionCardState extends State<NutritionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFF9F0), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFFFF6F00).withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Nutrition Guide',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFE65100),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFFF6F00),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.child_care_rounded,
                  'Age-appropriate feeding guidelines',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.auto_awesome_rounded,
                  'Key nutrients: Iron, Calcium, Vitamin D',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.family_restroom_rounded,
                  'Healthy feeding habits & routines',
                ),
                // Expandable Details
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedContent(),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  sizeCurve: Curves.easeInOut,
                ),
                if (!_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFE65100),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFFFF6F00),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainPoint(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB74D).withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF6F00),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFFBF360C),
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFFFF9800).withOpacity(0.33),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('What & How Much'),
        const SizedBox(height: 12),
        _subsectionTitle('Infants (0-6 months):'),
        const SizedBox(height: 8),
        _descriptionText(
          'Exclusive breastfeeding is best where possible. The World Health Organization (WHO) emphasizes that every child has the right to good nutrition.',
        ),
        const SizedBox(height: 12),
        _subsectionTitle('Transition to complementary foods (~6 months):'),
        const SizedBox(height: 8),
        _descriptionText(
          'Meals should be nutrient-dense, include multiple food groups, prepared hygienically, and eaten frequently.',
        ),
        const SizedBox(height: 12),
        _subsectionTitle('Toddlers (~12-24 months):'),
        const SizedBox(height: 8),
        _descriptionText(
          'Offer something to eat or drink every 2-3 hours (about 3 meals + 2-3 snacks).',
        ),
        const SizedBox(height: 12),
        _subsectionTitle('Older children (3-8 years):'),
        const SizedBox(height: 8),
        _descriptionText(
          'Focus on balanced diet: fruits/vegetables, whole grains, lean proteins, low-fat dairy, limit added sugars & sodium.',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Key Nutrients & Habits'),
        const SizedBox(height: 12),
        _bulletList([
          'Iron: Especially critical in infancy and toddler years — iron-rich foods should be offered early',
          'Calcium & Vitamin D: For bone health, especially when the child is older and more active',
          'Limit added sugars and ultra-processed snacks',
          'Fat intake: For children 2-3 years, total fat may be ~30-35% of calories; for older children ~25-35% (with fats from good sources)',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Feeding Habits'),
        const SizedBox(height: 12),
        _bulletList([
          'Routine: Encourage consistent meal/snack times so the child knows mealtime structure',
          'Self-feeding & autonomy: For toddlers/preschoolers, let them try feeding themselves (with supervision)',
          'Family meals: Children learn by watching caregivers\' eating habits',
          'Variety & texture progression: At ~6 months start soft purees → mashed → chopped → family-food textures by ~2-3 years',
          'Responsive feeding: Watch hunger/fullness cues; don\'t force eat',
          'Limit screen time during meals: Less distraction helps children tune into hunger/fullness cues',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Impact on Development & School Readiness'),
        const SizedBox(height: 12),
        _descriptionText(
          'Good nutrition supports brain growth, cognitive development, energy regulation and physical health — all of which tie into being ready for school (attention, behaviour, stamina).',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Local Tips for Pakistan'),
        const SizedBox(height: 12),
        _bulletList([
          'Use local foods: lentils (dal), whole wheat chapati, fresh seasonal fruits/vegetables, and local lean protein sources (eggs, chicken, fish)',
          'Water & hygiene: Emphasize clean water for cooking/feeding, safe storage',
          'Snack ideas: Instead of sugary biscuits, propose yogurt with fruit, roasted chickpeas, fresh fruit slices',
          'Cultural and family context: Encourage extended family involvement, sharing meals, and involving older siblings',
          'Micronutrient monitoring: Since iron-deficiency anemia is common in South Asia, include a "check iron" reminder around toddler age',
          'Growth tracking: Consider including local growth standards or WHO charts',
        ]),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFB74D).withOpacity(0.14),
                const Color(0xFFFF9800).withOpacity(0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF9800).withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: Color(0xFFFF6F00),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Nutritious foods should be offered throughout the day to ensure children are getting the nourishment and energy they need to learn and grow.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE65100),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Color(0xFFFF6F00),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _subsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
          color: Color(0xFFE65100),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.5,
          color: Color(0xFFBF360C),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Color(0xFFBF360C),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

