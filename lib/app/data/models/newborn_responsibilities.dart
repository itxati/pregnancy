import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

NewbornResponsibilities getNewbornResponsibilities() {
  return NewbornResponsibilities(
    title: 'newborn_responsibilities_title'.tr,
    sections: [
      InfoSection(
        title: 'why_important'.tr,
        points: [
          'establishes_legal_identity'.tr,
          'required_passport_school'.tr,
        ],
      ),
      InfoSection(
        title: 'how_register'.tr,
        points: [
          'register_60_days'.tr,
          'apply_union_council'.tr,
        ],
      ),
      InfoSection(
        title: 'documents_needed'.tr,
        points: [
          'hospital_birth_slip'.tr,
          'cnic_both_parents'.tr,
          'marriage_certificate'.tr,
          'application_form_signatures'.tr,
        ],
      ),
      InfoSection(
        title: 'nadra_form_b'.tr,
        points: [
          'required_school_passport_government_records'.tr,
          'bring_child_birth_certificate_parents_cnics'.tr,
          'one_parent_present_biometric_verification'.tr,
        ],
      ),
      InfoSection(
        title: 'hospital_documents_to_keep'.tr,
        points: [
          'discharge_summary_mother_child'.tr,
          'vaccination_card_record_started_birth'.tr,
          'medical_test_results_blood_group'.tr,
        ],
      ),
      InfoSection(
        title: 'vaccination_schedule'.tr,
        points: [
          'starts_immediately_after_birth'.tr,
          'record_epi_card'.tr,
          'keep_card_safe_updated'.tr,
        ],
      ),
      InfoSection(
        title: 'passport_application_if_needed'.tr,
        points: [
          'apply_after_form_b_registration'.tr,
          'submit_online_office_birth_certificate_form_b_parents_passports'.tr,
        ],
      ),
    ],
  );
}

// Keep the old const for backward compatibility, but it will use English
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
