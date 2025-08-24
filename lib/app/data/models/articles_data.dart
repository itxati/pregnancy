import 'package:babysafe/app/data/models/article.dart';

final List<ArticleModel> smallArticles = [
  ArticleModel(
    id: '1',
    title: 'How to calculate your due date',
    image: 'assets/logos/artical.jpeg',
    content:
        'To calculate your due date, count 280 days (40 weeks) from the first day of your last menstrual period. This method is commonly used by healthcare providers. Remember, only about 5% of babies are born on their actual due date!',
    isHorizontal: false,
  ),
  ArticleModel(
    id: '2',
    title: 'Spotting during pregnancy',
    image: 'assets/logos/article2.jpeg',
    content:
        'Spotting during pregnancy can be common, especially in the first trimester. However, always consult your doctor if you notice bleeding, as it can sometimes indicate a problem.',
    isHorizontal: false,
  ),
  ArticleModel(
    id: '3',
    title: 'Foods to avoid during pregnancy',
    image: 'assets/logos/article6.jpeg',
    content:
        'Certain foods should be avoided during pregnancy, such as raw fish, unpasteurized cheese, and deli meats. These can carry bacteria or parasites that may harm your baby.',
    isHorizontal: false,
  ),
];

final List<ArticleModel> largeArticles = [
  ArticleModel(
    id: '4',
    title: '5 widely believed pregnancy myths',
    image: 'assets/logos/article4.jpg',
    subtitle:
        "It can sometimes be hard to differentiate fact from fiction. Just because you've been...",
    content:
        '1. You can\'t exercise while pregnant: Moderate exercise is safe and healthy for most pregnancies.\n2. You must eat for two: You only need a little extra nutrition, not double!\n3. Heartburn means a hairy baby: There\'s no scientific link.\n4. You can\'t dye your hair: Most hair treatments are safe after the first trimester.\n5. Morning sickness only happens in the morning: It can occur at any time of day.',
    isHorizontal: true,
  ),
  ArticleModel(
    id: '5',
    title: 'Understanding prenatal vitamins',
    image: 'assets/logos/article5.webp',
    subtitle:
        'Prenatal vitamins are important for your baby\'s development. Here\'s what you need to know.',
    content:
        'Prenatal vitamins provide essential nutrients like folic acid, iron, and calcium. They help prevent birth defects and support your baby\'s growth. Take them daily as recommended by your doctor.',
    isHorizontal: true,
  ),
];
