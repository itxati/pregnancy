import 'package:flutter/material.dart';

class DeliveryPlanningCard extends StatefulWidget {
  const DeliveryPlanningCard({Key? key}) : super(key: key);

  @override
  State<DeliveryPlanningCard> createState() => _DeliveryPlanningCardState();
}

class _DeliveryPlanningCardState extends State<DeliveryPlanningCard>
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
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF66BB6A).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.06),
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
                          colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Delivery Planning & Labor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF2E7D32),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF4CAF50),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.edit_note_rounded,
                  'Plan your birth preferences and methods',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.warning_amber_rounded,
                  'Know signs of labor and when to go',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.emergency_rounded,
                  'Recognize red flags during labor',
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
                          color: const Color(0xFF66BB6A).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFF4CAF50),
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
            color: const Color(0xFF81C784).withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4CAF50),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1B5E20),
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
                const Color(0xFF66BB6A).withOpacity(0.33),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Delivery Planning Basics'),
        const SizedBox(height: 12),
        _descriptionText(
          'Know your birth plan, preferred delivery methods, and potential contingencies (emergency cesarean, vaginal birth after cesarean (VBAC) if appropriate).',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Signs of Labor'),
        const SizedBox(height: 12),
        _bulletList([
          'Regular contractions',
          'Water break (rupture of membranes)',
          'Backache',
          'Changes in baby movement patterns',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Transportation & Birth Plan'),
        const SizedBox(height: 12),
        _bulletList([
          'Know when to go to the hospital or birth center',
          'Have contact information ready',
          'Plan transportation in case of labor onset',
          'Prepare your birth plan documents',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Delivery Methods'),
        const SizedBox(height: 12),
        _bulletList([
          'Vaginal delivery',
          'Cesarean section',
          'Assisted vaginal delivery (forceps/vacuum) if needed',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Red Flags During Labor'),
        const SizedBox(height: 12),
        _bulletList([
          'Heavy bleeding',
          'Severe abdominal pain',
          'Persistent vomiting',
          'Signs of fetal distress',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Risk Assessment for Labor'),
        const SizedBox(height: 12),
        _bulletList([
          'Previous cesarean',
          'Placenta previa',
          'Breech presentation',
          'Multiple pregnancies',
          'Maternal chronic conditions',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Intrapartum Complications'),
        const SizedBox(height: 12),
        _bulletList([
          'Shoulder dystocia',
          'Fetal distress',
          'Non-reassuring fetal heart rate patterns',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Emergency Preparedness'),
        const SizedBox(height: 12),
        _descriptionText(
          'Know when to seek urgent care and what to expect. Have emergency contacts ready and understand your healthcare facility\'s protocols.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF81C784).withOpacity(0.14),
                const Color(0xFF66BB6A).withOpacity(0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF66BB6A).withOpacity(0.25),
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
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Always discuss your birth plan with your healthcare provider and have emergency contacts ready.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
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
              colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
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
            color: Color(0xFF4CAF50),
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
          color: Color(0xFF1B5E20),
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
                          colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
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
                          color: Color(0xFF1B5E20),
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

