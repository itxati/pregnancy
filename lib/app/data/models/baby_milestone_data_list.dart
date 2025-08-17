import 'baby_milestone_data.dart';

const List<BabyMilestone> babyMilestones = [
  BabyMilestone(
    month: 0,
    title: 'Newborn',
    milestones: [
      'Lifts head briefly when on tummy',
      'Makes eye contact',
      'Responds to sounds',
      'Grasps your finger',
      'Roots for feeding',
    ],
    description:
        'Your baby has just entered the world! This is a time of rapid adjustment and bonding.',
  ),
  BabyMilestone(
    month: 1,
    title: '1 Month',
    milestones: [
      'Holds head up for longer periods',
      'Follows objects with eyes',
      'Smiles in response to faces',
      'Makes cooing sounds',
      'Recognizes familiar voices',
    ],
    description:
        'Your baby is becoming more alert and responsive to the world around them.',
  ),
  // Added from trackmybabydata.txt
  BabyMilestone(
    month: 3,
    title: '3 Months',
    milestones: [
      'Follows light and tracks with eyes',
      'Regards mother’s face',
      'Turns toward nearby voices',
      'Shows happy response to caregiver’s face',
      'Laughs during pleasurable social contact',
      'Hands largely open; social smile appears',
      'Sleeps most of the time (more predictable patterns emerging)',
    ],
  ),
  BabyMilestone(
    month: 6,
    title: '6 Months',
    milestones: [
      'Rolls prone to supine (around 5 months) and supine to prone (around 6 months)',
      'Sits with back support',
      'Reaches out with one hand to grasp',
      'Eyes move in unison',
      'Vocalizes tunefully; shouts to attract attention',
      'Responds to sounds and simple words',
      'Explores by bringing objects to mouth',
      'Imitates simple gestures (e.g., bye-bye)',
    ],
  ),
  BabyMilestone(
    month: 9,
    title: '9 Months',
    milestones: [
      'Sits without support (often by 8 months)',
      'Reaches for a toy in front (around 9 months)',
      'Pivots to reach toy behind (around 10 months)',
      'Pulls to stand and cruises on furniture (may fall on bottom)',
      'Crawls/creeps on hands and knees',
      'Visually alert to peripheral movement; grasps string/objects',
      'Drops objects and looks for them (object permanence emerging)',
      'Babbles repeated syllables (e.g., “baba”, “dada”)',
      'Holds, bites, chews biscuits/soft foods',
      'Shows fear of strangers (from ~7 months)',
      'Waves and imitates hand clapping',
    ],
  ),
  BabyMilestone(
    month: 12,
    title: '12 Months',
    milestones: [
      'Walks with one hand held (around 12 months)',
      'Cruises along furniture; may take a few independent steps',
      'Watches small toys closely and points to desired objects',
      'Knows and responds to own name',
      'Says a few words',
      'Drinks from a cup with little assistance',
      'Waves bye-bye',
    ],
  ),
  BabyMilestone(
    month: 18,
    title: '18 Months',
    milestones: [
      'Walks alone, even with uneven steps',
      'Walks upstairs with one hand held',
      'Throws a ball',
    ],
  ),
];

const List<BabyHealthInfo> babyHealthInfos = [
  BabyHealthInfo(
    title: 'Newborn Jaundice',
    points: [
      'Yellowing of skin and eyes caused by high bilirubin.',
      'Common in newborns, usually appears within 2-4 days after birth.',
      'Monitor for yellow color spreading to legs, hands, or palms.',
      'Contact a doctor if baby is very sleepy, not feeding well, or jaundice appears within 24hrs of birth.',
    ],
    description:
        'Jaundice is usually harmless and goes away on its own, but some cases require medical attention.',
  ),
  // ... Add more health info sections ...
];

const BabyTip babyTips = BabyTip(
  dos: [
    'Feed your baby on demand.',
    'Keep baby warm and monitor feeding.',
    'Attend regular checkups.',
  ],
  donts: [
    'Do not ignore signs of illness.',
    'Avoid exposing baby to sick people.',
  ],
);

const List<BabyArticle> babyArticles = [
  BabyArticle(
    title: 'Newborn Responsibilities for Parents',
    content:
        'Register your child within 60 days of birth. Keep vaccination records safe. Apply for birth certificate and Form B as required.',
  ),
  // ... Add more articles ...
];

const List<BabyHealthInfo> jaundiceData = [
  BabyHealthInfo(
    title: 'Newborn Jaundice – What Every Mother Should Know',
    points: [
      'Jaundice is a common condition in newborns that causes yellowing of the skin and eyes',
      'It occurs when there is too much bilirubin (a yellow pigment) in the baby\'s blood',
      'Most cases appear 2-4 days after birth and resolve within 1-2 weeks',
      'Premature babies are more likely to develop jaundice than full-term babies',
      'Breastfeeding jaundice can occur when babies don\'t get enough breast milk',
      'Breast milk jaundice can develop after the first week and last for several weeks',
    ],
    description:
        'Understanding jaundice helps parents recognize when to seek medical attention and when it\'s normal.',
  ),
  BabyHealthInfo(
    title: 'Signs and Symptoms of Jaundice',
    points: [
      'Yellowing of the skin, starting from the face and moving downward',
      'Yellowing of the whites of the eyes (sclera)',
      'Dark yellow urine instead of clear or light yellow',
      'Pale, clay-colored stools instead of yellow or green',
      'Poor feeding or difficulty waking for feeds',
      'High-pitched crying or unusual fussiness',
      'Lethargy or excessive sleepiness',
    ],
    description:
        'Early recognition of jaundice symptoms is crucial for timely treatment.',
  ),
  BabyHealthInfo(
    title: 'Risk Factors for Severe Jaundice',
    points: [
      'Premature birth (before 37 weeks)',
      'Blood type incompatibility between mother and baby',
      'Bruising during birth (causes more red blood cell breakdown)',
      'Family history of jaundice or blood disorders',
      'Insufficient feeding in the first few days',
      'Certain genetic conditions affecting red blood cells',
      'Infection or other medical conditions',
    ],
    description:
        'Babies with these risk factors need closer monitoring for jaundice.',
  ),
  BabyHealthInfo(
    title: 'When to Seek Medical Attention',
    points: [
      'Jaundice appears within 24 hours of birth',
      'Yellow color spreads to arms, legs, or palms',
      'Baby is very sleepy and difficult to wake for feeds',
      'Baby is not feeding well or refusing to eat',
      'Jaundice lasts longer than 2 weeks',
      'Baby develops fever or other signs of illness',
      'Jaundice is accompanied by dark urine or pale stools',
      'Baby becomes increasingly irritable or fussy',
    ],
    description:
        'Immediate medical attention is needed for severe jaundice to prevent complications.',
  ),
  BabyHealthInfo(
    title: 'Treatment Options for Jaundice',
    points: [
      'Phototherapy (light therapy) using special blue lights',
      'Increased feeding to help eliminate bilirubin through stool',
      'Intravenous fluids if baby is dehydrated',
      'Exchange transfusion in severe cases (rare)',
      'Home phototherapy devices for mild cases',
      'Frequent feeding every 2-3 hours to promote bowel movements',
      'Monitoring bilirubin levels through blood tests',
    ],
    description:
        'Most jaundice cases are mild and resolve with simple treatments.',
  ),
  BabyHealthInfo(
    title: 'Prevention and Home Care',
    points: [
      'Feed baby frequently (every 2-3 hours) to promote regular bowel movements',
      'Ensure adequate milk intake to prevent dehydration',
      'Expose baby to natural sunlight (not direct sun) for short periods',
      'Monitor baby\'s feeding, sleeping, and alertness patterns',
      'Keep track of wet and dirty diapers',
      'Avoid over-bundling baby which can cause dehydration',
      'Follow doctor\'s recommendations for follow-up appointments',
    ],
    description:
        'Proper feeding and monitoring are key to preventing severe jaundice.',
  ),
  BabyHealthInfo(
    title: 'Complications of Untreated Jaundice',
    points: [
      'Kernicterus - a rare but serious brain damage condition',
      'Hearing loss or deafness',
      'Vision problems or blindness',
      'Developmental delays or learning disabilities',
      'Movement disorders or cerebral palsy',
      'Intellectual disabilities',
      'Seizures or other neurological problems',
    ],
    description:
        'Severe untreated jaundice can have serious long-term consequences.',
  ),
  BabyHealthInfo(
    title: 'Breastfeeding and Jaundice',
    points: [
      'Breastfeeding jaundice occurs when baby doesn\'t get enough milk',
      'Breast milk jaundice is different and usually harmless',
      'Continue breastfeeding even if baby has jaundice',
      'Feed baby at least 8-12 times per day in the first week',
      'Ensure proper latch and feeding technique',
      'Wake baby for feeds if they sleep longer than 3-4 hours',
      'Seek help from a lactation consultant if feeding is difficult',
      'Monitor baby\'s weight gain and diaper output',
    ],
    description:
        'Proper breastfeeding techniques can help prevent and manage jaundice.',
  ),
];
