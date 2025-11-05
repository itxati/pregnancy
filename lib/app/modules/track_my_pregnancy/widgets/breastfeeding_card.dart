import 'package:flutter/material.dart';

class BreastfeedingCard extends StatefulWidget {
  const BreastfeedingCard({Key? key}) : super(key: key);

  @override
  State<BreastfeedingCard> createState() => _BreastfeedingCardState();
}

class _BreastfeedingCardState extends State<BreastfeedingCard>
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
          colors: [Color(0xFFFFF5E6), Color(0xFFFFF9F0), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB84D).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFFFF9500).withOpacity(0.06),
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
                          colors: [Color(0xFFFFB84D), Color(0xFFFFD699)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.child_care_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Breastfeeding & Feeding',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFB87300),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB84D).withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFFF9500),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.favorite_rounded,
                  'Optimal nutrition & immunity for baby',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.auto_awesome_rounded,
                  'Colostrum: first milk rich in antibodies',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.restaurant_rounded,
                  'Three types: exclusive, mixed, or formula',
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
                          color: const Color(0xFFFFB84D).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFB87300),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFFFF9500),
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
            color: const Color(0xFFFFD699).withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF9500),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF7A5A00),
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
                const Color(0xFFFFB84D).withOpacity(0.33),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Benefits of Breastfeeding'),
        const SizedBox(height: 12),
        _descriptionText(
          'Breastfeeding provides optimal nutrition, immunity, bonding support, and health benefits for both mother and baby.',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Colostrum'),
        const SizedBox(height: 12),
        _descriptionText(
          'Colostrum is the first milk, rich in antibodies and nutrients. It starts immediately after birth and gradually transitions to mature milk.',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Types of Feeding'),
        const SizedBox(height: 12),
        _bulletList([
          'Exclusive breastfeeding: only breast milk (no other liquids or solids except vitamins or medications as advised)',
          'Mixed feeding: breast milk plus formula or other feeds',
          'Exclusive formula feeding: no breast milk',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Introducing Complementary Foods'),
        const SizedBox(height: 12),
        _descriptionText(
          'Start around 6 months of age for most babies, with continued breastfeeding or formula feeding.',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Common Challenges & Solutions'),
        const SizedBox(height: 12),
        _bulletList([
          'Latching issues: seek help from lactation consultants',
          'Nipple pain: check positioning and latch',
          'Milk supply concerns: frequent feeding helps',
          'Pumping/expressing guidelines: follow safe practices',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Safety'),
        const SizedBox(height: 12),
        _bulletList([
          'Maintain good hygiene practices',
          'Safe storage of expressed milk',
          'Avoid certain substances that can pass to baby',
        ]),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFD699).withOpacity(0.14),
                const Color(0xFFFFB84D).withOpacity(0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFB84D).withOpacity(0.25),
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
                  color: Color(0xFFFF9500),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Consult with lactation specialists or healthcare providers for personalized feeding guidance.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB87300),
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
              colors: [Color(0xFFFFB84D), Color(0xFFFF9500)],
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
            color: Color(0xFFFF9500),
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
          color: Color(0xFF7A5A00),
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
                          colors: [Color(0xFFFFB84D), Color(0xFFFF9500)],
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
                          color: Color(0xFF7A5A00),
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

