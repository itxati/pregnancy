import 'package:babysafe/app/data/models/article.dart';

final List<ArticleModel> smallBabyArticles = [
  ArticleModel(
    id: '1',
    title: 'Baby sleep patterns by age',
    image: 'assets/logos/sleeppatteren.png',
    content:
        'Newborns sleep 16-17 hours a day, but only 1-2 hours at a time. By 3-4 months, babies start developing more regular sleep patterns. Understanding your baby\'s sleep needs helps establish healthy routines.',
    isHorizontal: false,
  ),
  ArticleModel(
    id: '2',
    title: 'Essential baby care tips',
    image: 'assets/logos/babycare.jpg',
    content:
        'Always support your baby\'s head and neck, keep them clean and dry, and respond promptly to their cries. Regular feeding, changing, and gentle interaction are key to your baby\'s development.',
    isHorizontal: false,
  ),
  ArticleModel(
    id: '3',
    title: 'Safe sleeping guidelines',
    image: 'assets/logos/safesleeping.jpeg',
    content:
        'Place your baby on their back to sleep, use a firm sleep surface, and keep soft objects and loose bedding away. Room sharing without bed sharing is recommended for the first 6-12 months.',
    isHorizontal: false,
  ),
];

final List<ArticleModel> largeBabyArticles = [
  ArticleModel(
    id: '4',
    title: '5 common baby development myths',
    image: 'assets/logos/babymyths.jpg',
    subtitle:
        "Separating fact from fiction about your baby's growth and development...",
    content:
        '1. Babies need to be stimulated constantly: Babies also need quiet time and rest.\n2. Crying means something is wrong: Crying is normal communication for babies.\n3. You can spoil a baby by holding them too much: You cannot spoil a newborn with attention.\n4. Babies should sleep through the now: Most babies wake up during the night until 6-12 months.\n5. Teething causes fever: Teething may cause slight temperature rise but not true fever.',
    isHorizontal: true,
  ),
  ArticleModel(
    id: '5',
    title: 'Understanding baby milestones',
    image: 'assets/logos/babymilestone.jpg',
    subtitle:
        'Every baby develops at their own pace. Here\'s what to expect and when.',
    content:
        'Baby milestones are guidelines, not strict rules. Most babies smile by 2 months, roll over by 4-6 months, sit up by 6-8 months, and take first steps by 9-15 months. Remember, every baby is unique and develops at their own pace.',
    isHorizontal: true,
  ),
];
