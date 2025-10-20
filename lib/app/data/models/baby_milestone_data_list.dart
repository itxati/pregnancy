import 'baby_milestone_data.dart';

const List<BabyMilestone> babyMilestones = [
  BabyMilestone(
    imageUrl: 'assets/afterbirth/4.jpg',
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
  // 2–8 years extension
  BabyMilestone(
    imageUrl: 'assets/afterbirth/2.jpg',
    month: 24,
    title: '2–3 Years',
    milestones: [
      'Walks and runs with better balance; begins climbing; may pedal tricycle',
      'Uses 2–3 word sentences; follows simple instructions; points to named pictures; pretend play begins',
      'Gaining independence; some defiance; parallel play emerges',
      'Scribbles, stacks blocks, turns knobs',
    ],
    description:
        'Early toddler years bring rapid gains in motor control, language, and social independence.',
  ),
  BabyMilestone(
    imageUrl: 'assets/afterbirth/3.jpg',
    month: 36,
    title: '3–4 Years',
    milestones: [
      'Improved balance; hops and jumps; climbs stairs alternating feet',
      'Speaks in full sentences; asks “why?”; counts small numbers; sorts by shape/color; richer pretend play',
      'Takes turns; shows affection; more cooperative play',
      'Copies shapes; begins using scissors; dresses/undresses with help',
    ],
  ),
  BabyMilestone(
    imageUrl: 'assets/afterbirth/4.jpg',
    month: 48,
    title: '4–5 Years',
    milestones: [
      'Runs, throws, and catches more reliably; rides tricycle well',
      'Recognizes letters/numbers; recalls simple stories; understands same vs different; basic reasoning',
      'Expresses emotions; engages in social play; starts grasping rules',
      'Draws a person with parts; cuts shapes; writes some letters',
    ],
  ),
  BabyMilestone(
    imageUrl: 'assets/afterbirth/1.jpg',
    month: 60,
    title: '5–6 Years',
    milestones: [
      'Refined coordination; better control in drawing and daily tasks',
      'Reading readiness; basic math concepts (counting, simple operations); more logical thinking',
      'Greater self-control; cooperates with peers; understands fairness',
      'Improved pencil grip; writes own name; increased task precision',
    ],
  ),
  BabyMilestone(
    imageUrl: 'assets/afterbirth/2.jpg',
    month: 72,
    title: '6–8 Years',
    milestones: [
      'Skill refinement continues (handwriting, sports, coordination)',
      'Shifts toward concrete operational thinking (logical operations on real objects)',
      'Deeper peer relationships; stronger rule-following and moral sense; self-esteem linked to success',
      'Complex drawings; neater handwriting; more intricate crafts',
    ],
  ),
  BabyMilestone(
    imageUrl: 'assets/afterbirth/3.jpg',
    month: 96,
    title: '8 Years Overview',
    milestones: [
      'Consolidates skills across academics and sports; better endurance',
      'More consistent logical reasoning; growing academic independence',
      'Stable friendships; empathy and rule understanding strengthen',
      'Organized, detailed work products (writing, crafts, projects)',
    ],
    description:
        'By ~8 years, children show more stable cognitive, social, and motor patterns; experiences remain highly impactful.',
  ),
  BabyMilestone(
    imageUrl: 'assets/afterbirth/1.jpg',
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
    imageUrl: 'assets/afterbirth/2.jpg',
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
    imageUrl: 'assets/afterbirth/3.jpg',
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
    imageUrl: 'assets/afterbirth/4.jpg',
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
    imageUrl: 'assets/afterbirth/1.jpg',
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
    imageUrl: 'assets/afterbirth/2.jpg',
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
  // Teething / Dental Development (2–8 years relevance)
  BabyHealthInfo(
    title: 'Teething and Dental Development',
    points: [
      'Primary teeth eruption typically completes around 2–3 years',
      'Sequence often: central incisors, lateral incisors, first molars, canines, second molars',
      'Focus after eruption: daily brushing, fluoride as advised, routine checks',
      'Watch for tooth decay; baby teeth health affects speech and permanent teeth',
      'Supervise brushing; teach proper technique and duration',
    ],
    description:
        'Healthy dental habits in early childhood prevent decay and support speech, chewing, and long-term oral health.',
  ),
  // Vaccination (Immunization) for Ages 2–8
  BabyHealthInfo(
    title: 'Vaccination (Ages 2–8)',
    points: [
      'Booster doses in early childhood (e.g., DTP) are common',
      'Some programs include MMR, varicella, polio boosters, annual influenza',
      'Schedules vary by country; follow local EPI guidance',
      'Keep records updated; bring card to school and checkups',
      'Consult your provider for catch-up doses if any were missed',
    ],
    description:
        'Follow your local immunization schedule for boosters between 2–8 years to maintain protection.',
  ),
  // School Readiness & Early Education
  BabyHealthInfo(
    title: 'School Readiness and Early Education',
    points: [
      'Domains: social-emotional, language/literacy, numeracy, physical health, learning approaches',
      'Language & literacy: phonological awareness, vocabulary, narratives, letter-sound links',
      'Math: counting, sorting, patterns, basic operations using real objects',
      'Social skills: cooperation, self-regulation, understanding emotions, rules',
      'Support transitions preschool → grade 1; monitor and support lagging skills',
      'Use developmentally appropriate practice aligned with local frameworks',
    ],
    description:
        'Strong early skills and supportive transitions improve school adjustment and later achievement.',
  ),
  // Ages 2–8 Overview
  BabyHealthInfo(
    title: 'Ages 2–8 Overview',
    points: [
      'First 0–8 years are critical; brain circuits wire rapidly; experiences have strong impact',
      'Foundations: good nutrition, responsive caregiving, stimulation, safety, health and education access',
      'Early learning programs reduce dropout, improve readiness, strengthen later performance',
      'Use developmentally appropriate practice: align expectations with age and individual differences',
    ],
    description:
        'Early childhood experiences shape cognitive, emotional, and physical outcomes across life.',
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
