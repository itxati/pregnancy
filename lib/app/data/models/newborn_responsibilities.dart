import 'package:flutter/foundation.dart';

@immutable
class InfoSection {
  final String title;
  final List<String> points;

  const InfoSection({required this.title, required this.points});
}

@immutable
class NewbornResponsibilities {
  final String title;
  final List<InfoSection> sections;

  const NewbornResponsibilities({required this.title, required this.sections});
}

const NewbornResponsibilities newbornResponsibilities = NewbornResponsibilities(
  title: 'Newborn Responsibilities for Parents After Child Birth',
  sections: [
    InfoSection(
      title: 'Why is it important?',
      points: [
        'Establishes the child\'s legal identity',
        'Required for passport, school admission, and health insurance',
      ],
    ),
    InfoSection(
      title: 'How to register?',
      points: [
        'Register within 60 days of birth',
        'Apply at your local Union Council or NADRA office',
      ],
    ),
    InfoSection(
      title: 'Documents needed',
      points: [
        'Hospital birth slip',
        'CNIC of both parents',
        'Marriage certificate',
        'Application form with signatures',
      ],
    ),
    InfoSection(
      title: 'NADRA Form B (after Birth Certificate)',
      points: [
        'Required for school admission, passport, and government records',
        'Bring: Child\'s birth certificate and parents\' CNICs',
        'One parent must be present for biometric verification',
      ],
    ),
    InfoSection(
      title: 'Hospital documents to keep',
      points: [
        'Discharge summary for mother and child',
        'Vaccination card/record started at birth',
        'Any medical test results (including blood group)',
      ],
    ),
    InfoSection(
      title: 'Vaccination schedule',
      points: [
        'Starts immediately after birth',
        'Record on the EPI card',
        'Keep the card safe and updated',
      ],
    ),
    InfoSection(
      title: 'Passport application (if needed)',
      points: [
        'Apply after Form B registration',
        'Submit online or at the office with: Birth certificate, Form B, Parents\' passports',
      ],
    ),
  ],
);
