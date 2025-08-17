import 'postpartum_models.dart';

const PostpartumContent postpartumContent = PostpartumContent(
  physicalChanges: [
    InfoSection(title: 'Physical Changes After Delivery', items: [
      InfoItem(
          title: 'Uterine Involution',
          description: 'Uterus returns to pre-pregnancy size'),
      InfoItem(
          title: 'Lochia',
          description:
              'Vaginal discharge that changes from red/pink to yellow/white'),
      InfoItem(
          title: 'Perineal Healing',
          description: 'Recovery from episiotomy or tearing'),
      InfoItem(
          title: 'Cesarean Recovery',
          description: 'Incision care, mobility, and pain management'),
    ]),
  ],
  emotionalMental: [
    InfoSection(title: 'Emotional and Mental Health', items: [
      InfoItem(
          title: 'Baby Blues',
          description:
              'Mood swings, crying, anxiety — common in the first 2 weeks'),
      InfoItem(
          title: 'Postpartum Depression',
          description: 'Persistent sadness, fatigue — needs medical attention'),
      InfoItem(
          title: 'Postpartum Anxiety',
          description: 'Less common but serious — medical attention needed'),
    ]),
  ],
  commonConcerns: [
    InfoSection(title: 'Common Concerns & Complications', items: [
      InfoItem(
          title: 'Infection Signs',
          description: 'Fever, foul-smelling lochia, wound redness'),
      InfoItem(
          title: 'Heavy Bleeding (PPH)', description: 'More than 1 pad/hour'),
      InfoItem(
          title: 'Urinary Issues', description: 'Incontinence or retention'),
      InfoItem(title: 'Constipation & Hemorrhoids'),
      InfoItem(title: 'Breast Infection (Mastitis)'),
    ]),
  ],
  tips: Tips(
    dos: [
      'Eat as much as possible',
      'Eat nutritious foods (iron, protein)',
      'Keep the perineum dry and clean',
      'Do gentle pelvic floor exercises (Kegels)',
      'Attend postnatal checkups (usually at 6 weeks)',
      'Ask for help (physical & emotional)',
    ],
    donts: [
      'Avoid heavy lifting for 6 weeks',
      'Don’t insert anything into the vagina (tampons/sex)',
      'Don’t skip meals (it affects energy and breastfeeding)',
      'Don’t ignore signs of depression or excessive bleeding',
    ],
  ),
  breastfeeding: BreastfeedingContent(
    sections: [
      BreastfeedingSection(title: 'Early Initiation', bullets: [
        'Should begin within 1 hour after birth if mother & baby are stable',
        'Skin-to-skin contact encourages immediate breastfeeding to:',
        'Stimulate oxytocin release',
        'Trigger milk let-down reflex',
        'Support thermoregulation',
      ]),
      BreastfeedingSection(title: 'Hormonal Control', bullets: [
        'Prolactin → Stimulates milk production',
        'Oxytocin → Causes milk ejection reflex',
      ]),
      BreastfeedingSection(title: 'Frequency', bullets: [
        'Newborn should breastfeed 8–12 times/24 hours',
        'On-demand feeding is preferred — cues include rooting, hand to mouth, fussing',
      ]),
      BreastfeedingSection(title: 'Monitor Intake & Output', bullets: [
        'Wet Diapers: At least 6 wet diapers per day after day 5',
        'Stool: Yellow, seedy stools by day 5',
        'Weight: Expected weight loss <10% of birth weight in the first week; regain by day 10–14',
      ]),
    ],
    challenges: [
      Challenge(title: 'Engorgement', management: [
        'Frequent feeding',
        'Cold compress',
        'Gentle massage',
        'Correct positioning',
      ]),
      Challenge(title: 'Sore Nipples', management: [
        'Often due to poor latch',
        'Correct positioning',
      ]),
      Challenge(title: 'Blocked Duct', management: [
        'Warm compress',
        'Massage',
        'Feed frequently',
      ]),
      Challenge(title: 'Mastitis', management: [
        'Infection – red, swollen area with fever',
        'Continue breastfeeding',
        'Antibiotics if bacterial',
      ]),
      Challenge(title: 'Low Milk Supply (Perceived or Real)', management: [
        'Evaluate latch, hydration',
        'Consider galactagogues if necessary (e.g. domperidone – medical supervision only)',
      ]),
    ],
    whenToSeekHelp: [
      'Fever over 100°F',
      'Severe abdominal pain',
      'Foul-smelling vaginal discharge',
      'Thoughts of harming self or baby',
      'Pain or swelling in leg (risk of DVT)',
    ],
    contraindications: [
      'HIV – if the mother is untreated',
      'Mother receiving chemo or radiation',
      'Infant with galactosemia',
    ],
  ),
  familyPlanning: FamilyPlanningContent(
    whyImportant: [
      'Closely spaced pregnancies cause health risks for mother and baby',
      'Helps mothers recover emotionally and physically',
      'Supports better childcare and bonding',
    ],
    whenToStart: [
      'Ovulation can return as early as weeks postpartum',
      'Breastfeeding women may get up to 6 months via LAM',
    ],
    categories: [
      Category(title: 'Natural', methods: [
        MethodDetail(name: 'LAM (Lactational Amenorrhea Method)', points: [
          'Under 6 months',
          'Exclusive breastfeeding',
        ]),
      ]),
      Category(title: 'Hormonal Methods', methods: [
        MethodDetail(name: 'Progestin-only pills', points: [
          'Safest during breastfeeding',
          'Start at 6 weeks postpartum',
          'Must be taken at the same time daily',
        ]),
        MethodDetail(name: 'Combined oral contraceptives', points: [
          'Not recommended before 6 months if breastfeeding',
          'Start after 3 weeks if not breastfeeding',
        ]),
        MethodDetail(name: 'Injectable contraceptives (DMPA)', points: [
          'Effective for 3 months',
          'Safe during breastfeeding',
          'Can be started at 6 weeks postpartum',
        ]),
      ]),
      Category(title: 'Implants', methods: [
        MethodDetail(name: 'Subdermal implants', points: [
          'Long term (3–5 years)',
          'Inserted under skin',
          'Safe for breastfeeding',
          'Can be inserted 6 weeks postpartum',
        ]),
      ]),
      Category(title: 'Barrier Methods', methods: [
        MethodDetail(name: 'Condoms', points: [
          'Prevent STDs',
          'Can be used immediately after delivery',
        ]),
        MethodDetail(name: 'Diaphragm/Cervical cap', points: [
          'Require fitting by a health care provider',
          'Wait until 6 weeks postpartum',
        ]),
      ]),
      Category(title: 'IUDs', methods: [
        MethodDetail(name: 'Copper IUD', points: [
          'Hormone-free',
          'Lasts up to 10 years',
        ]),
        MethodDetail(name: 'LNG-IUS Hormonal IUD', points: [
          'Provides local hormone release',
          'Lasts 3–5 years',
          'Reduces bleeding',
        ]),
      ]),
      Category(title: 'Permanent Methods', methods: [
        MethodDetail(name: 'Male sterilization (Vasectomy)', points: [
          'Safer, outpatient procedure',
          'Delayed effectiveness (use backup for 3 months)',
        ]),
        MethodDetail(name: 'Female sterilization (Tubal ligation)', points: [
          'Done at time of Caesarean or 1 week after vaginal birth',
          'Permanent, non-reversible',
        ]),
      ]),
    ],
    considerations: [
      'Breastfeeding status',
      'Medical history',
      'Age and family size',
      'Cultural/religious beliefs',
      'Personal preferences and partner involvement',
    ],
  ),
);
