import 'package:flutter/material.dart';

class PretermBirthCard extends StatefulWidget {
  const PretermBirthCard({Key? key}) : super(key: key);

  @override
  State<PretermBirthCard> createState() => _PretermBirthCardState();
}

class _PretermBirthCardState extends State<PretermBirthCard>
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
          colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6DADE4).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.06),
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
                          colors: [Color(0xFF6DADE4), Color(0xFFBBDEFB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.baby_changing_station_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Preterm Birth Awareness',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF0D47A1),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF6DADE4).withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF1976D2),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.schedule_rounded,
                  'Birth before 37 completed weeks',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.baby_changing_station_rounded,
                  'Types: Late, Moderate, Very Early Preterm',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.stacked_bar_chart_rounded,
                  'Higher risks for babies born preterm',
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
                          color: const Color(0xFF6DADE4).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0D47A1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFF1976D2),
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
            color: const Color(0xFFBBDEFB).withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF15446E),
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
                const Color(0xFF6DADE4).withOpacity(0.33),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('What is preterm birth?'),
        const SizedBox(height: 12),
        _descriptionText(
          'Preterm birth means giving birth before 37 completed weeks of gestation. The earlier a baby is born, the greater the risk of health problems.',
        ),
        const SizedBox(height: 18),
        _sectionTitle('Types of preterm birth'),
        const SizedBox(height: 12),
        _bulletList([
          'Late preterm: 34 0/7 to 36 6/7 weeks',
          'Moderate preterm: 32 0/7 to 33 6/7 weeks',
          'Very early preterm: <32 weeks',
        ]),
        const SizedBox(height: 18),
        _sectionTitle('Why it matters'),
        const SizedBox(height: 12),
        _bulletList([
          'Higher risk of respiratory issues',
          'Feeding difficulties',
          'Temperature instability',
          'Longer hospital stays',
        ]),
        const SizedBox(height: 18),
        _sectionTitle('Risk factors'),
        const SizedBox(height: 12),
        _bulletList([
          'Maternal infections or chronic diseases',
          'History of prior preterm birth',
          'Placenta problems',
          'Obstetric complications',
          'Smoking, substance use',
          'Maternal stress',
        ]),
        const SizedBox(height: 18),
        _sectionTitle('Prevention and management'),
        const SizedBox(height: 12),
        _bulletList([
          'Progesterone therapy in some high-risk pregnancies',
          'Treating infections promptly',
          'Cervical cerclage in selected cases',
          'Managing anxiety and depression',
          'Ensuring access to perinatal & neonatal care',
        ]),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFBBDEFB).withOpacity(0.14),
                const Color(0xFF6DADE4).withOpacity(0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF6DADE4).withOpacity(0.25),
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
                  color: Color(0xFF1976D2),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Regular checkups and healthy habits can reduce the risk of preterm birth.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D47A1),
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
              colors: [Color(0xFF6DADE4), Color(0xFF1976D2)],
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
            color: Color(0xFF1976D2),
            letterSpacing: -0.3,
          ),
        ),
      ],
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
          color: Color(0xFF15446E),
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
                          colors: [Color(0xFF6DADE4), Color(0xFF1976D2)],
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
                          color: Color(0xFF15446E),
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
