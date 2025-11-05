import 'package:flutter/material.dart';

class PregnancyRiskFactorsCard extends StatefulWidget {
  const PregnancyRiskFactorsCard({Key? key}) : super(key: key);

  @override
  State<PregnancyRiskFactorsCard> createState() =>
      _PregnancyRiskFactorsCardState();
}

class _PregnancyRiskFactorsCardState extends State<PregnancyRiskFactorsCard>
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
          colors: [Color(0xFFFFEBEE), Color(0xFFFFF5F5), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF5350).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFFE53935).withOpacity(0.06),
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
                          colors: [Color(0xFFEF5350), Color(0xFFFF8A80)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Risk Factors & Danger Signs',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFC62828),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350).withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFE53935),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.bloodtype_rounded,
                  'Anemia: common in pregnancy',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.health_and_safety_rounded,
                  'Multiple risk factors to be aware of',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.emergency_rounded,
                  'Know danger signs requiring urgent care',
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
                          color: const Color(0xFFEF5350).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFC62828),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFFE53935),
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
            color: const Color(0xFFFF8A80).withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE53935),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFFB71C1C),
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
                const Color(0xFFEF5350).withOpacity(0.33),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Anemia in Pregnancy'),
        const SizedBox(height: 12),
        _descriptionText(
          'Anemia is common in pregnancy. Risk factors include iron deficiency, dietary insufficiency, and increased iron demands. Symptoms can be subtle, so routine screening is standard.',
        ),
        const SizedBox(height: 12),
        _subsectionTitle('Management:'),
        const SizedBox(height: 8),
        _bulletList([
          'Dietary iron intake',
          'Vitamin C co-supplementation',
          'Prescribed iron if deficiency is found',
          'Monitor hemoglobin/hematocrit levels',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Other Major Risk Factors'),
        const SizedBox(height: 12),
        _bulletList([
          'Hypertension',
          'Diabetes',
          'Kidney disease',
          'Autoimmune disorders',
          'Infections',
          'Advanced maternal age',
          'Cigarette smoking',
          'Substance use',
          'Previous obstetric complications',
          'Undernutrition',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Danger Signs in Pregnancy'),
        const SizedBox(height: 12),
        _descriptionText(
          'Seek immediate medical attention if you experience any of these danger signs:',
        ),
        const SizedBox(height: 12),
        _bulletList([
          'Severe vaginal bleeding',
          'Severe or persistent headaches with vision changes',
          'Swelling of hands/face',
          'Severe abdominal pain',
          'Decreased fetal movement',
          'Fever/chills',
          'Severe vomiting',
          'Dizziness or fainting',
          'Gush of fluid indicating rupture of membranes',
        ]),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF8A80).withOpacity(0.14),
                const Color(0xFFEF5350).withOpacity(0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFEF5350).withOpacity(0.25),
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
                  Icons.emergency_rounded,
                  color: Color(0xFFE53935),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'If you experience any danger signs, seek immediate medical care. Regular prenatal checkups help monitor and manage risk factors.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC62828),
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
              colors: [Color(0xFFEF5350), Color(0xFFE53935)],
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
            color: Color(0xFFE53935),
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
          color: Color(0xFFC62828),
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
          color: Color(0xFFB71C1C),
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
                          colors: [Color(0xFFEF5350), Color(0xFFE53935)],
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
                          color: Color(0xFFB71C1C),
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

