class BabyDevelopmentData {
  final int month;
  final String title;
  final String description;
  final String physicalDevelopment;
  final String cognitiveDevelopment;
  final String socialDevelopment;
  final String healthTips;
  final String feedingInfo;
  final String sleepInfo;
  final String weight;
  final String height;
  final String headCircumference;
  final List<String> milestones;
  final String imageAsset;

  const BabyDevelopmentData({
    required this.month,
    required this.title,
    required this.description,
    required this.physicalDevelopment,
    required this.cognitiveDevelopment,
    required this.socialDevelopment,
    required this.healthTips,
    required this.feedingInfo,
    required this.sleepInfo,
    required this.weight,
    required this.height,
    required this.headCircumference,
    required this.milestones,
    required this.imageAsset,
  });
}

// Baby development data from birth to 24 months
const List<BabyDevelopmentData> babyDevelopmentData = [
  // Month 0 (Newborn)
  BabyDevelopmentData(
    month: 0,
    title: "Newborn",
    description:
        "Your baby has just entered the world! This is a time of rapid adjustment and bonding.",
    physicalDevelopment:
        "Your newborn can lift their head briefly when on their tummy. They have strong reflexes and can grasp your finger.",
    cognitiveDevelopment:
        "Your baby can see faces and objects 8-12 inches away. They recognize your voice and prefer looking at faces.",
    socialDevelopment:
        "Your baby communicates through crying and makes eye contact. They are learning to trust and bond with you.",
    healthTips:
        "Ensure your baby gets plenty of skin-to-skin contact. Keep them warm and monitor their feeding and diaper changes.",
    feedingInfo:
        "Feed on demand, typically 8-12 times per day. Breast milk or formula provides all necessary nutrition.",
    sleepInfo:
        "Newborns sleep 14-17 hours per day in short periods. They don't have a day/night rhythm yet.",
    weight: "2.5-4.5 kg",
    height: "45-55 cm",
    headCircumference: "32-36 cm",
    milestones: [
      "Lifts head briefly when on tummy",
      "Makes eye contact",
      "Responds to sounds",
      "Grasps your finger",
      "Roots for feeding",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 1
  BabyDevelopmentData(
    month: 1,
    title: "1 Month Old",
    description:
        "Your baby is becoming more alert and responsive to the world around them.",
    physicalDevelopment:
        "Your baby can hold their head up for longer periods and may start to follow objects with their eyes.",
    cognitiveDevelopment:
        "Your baby recognizes familiar faces and voices. They may start to coo and make vowel sounds.",
    socialDevelopment:
        "Your baby smiles in response to your face and voice. They are learning to communicate through sounds.",
    healthTips:
        "Continue with tummy time to strengthen neck muscles. Monitor feeding patterns and weight gain.",
    feedingInfo:
        "Still feeding 8-12 times per day. Watch for feeding cues and ensure adequate weight gain.",
    sleepInfo:
        "Sleeping 14-16 hours per day. Starting to develop more regular sleep patterns.",
    weight: "3.5-5.5 kg",
    height: "50-60 cm",
    headCircumference: "35-38 cm",
    milestones: [
      "Holds head up for longer periods",
      "Follows objects with eyes",
      "Smiles in response to faces",
      "Makes cooing sounds",
      "Recognizes familiar voices",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 2
  BabyDevelopmentData(
    month: 2,
    title: "2 Months Old",
    description:
        "Your baby is becoming more social and interactive. They're starting to show their personality!",
    physicalDevelopment:
        "Your baby can hold their head steady and may start to push up when on their tummy.",
    cognitiveDevelopment:
        "Your baby follows moving objects and recognizes familiar faces. They may start to reach for objects.",
    socialDevelopment:
        "Your baby smiles socially and may start to laugh. They're becoming more responsive to your interactions.",
    healthTips:
        "Continue tummy time and start introducing gentle play. Monitor developmental milestones.",
    feedingInfo:
        "Feeding 7-9 times per day. Watch for feeding cues and ensure adequate weight gain.",
    sleepInfo:
        "Sleeping 12-15 hours per day. Starting to develop more predictable sleep patterns.",
    weight: "4.5-6.5 kg",
    height: "55-65 cm",
    headCircumference: "37-40 cm",
    milestones: [
      "Holds head steady",
      "Pushes up when on tummy",
      "Follows moving objects",
      "Smiles socially",
      "Makes gurgling sounds",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 3
  BabyDevelopmentData(
    month: 3,
    title: "3 Months Old",
    description:
        "Your baby is becoming more coordinated and may start to roll over!",
    physicalDevelopment:
        "Your baby can roll from tummy to back and may start to reach for and grasp objects.",
    cognitiveDevelopment:
        "Your baby recognizes familiar objects and people. They may start to babble and make consonant sounds.",
    socialDevelopment:
        "Your baby laughs and squeals with delight. They're becoming more interactive and playful.",
    healthTips:
        "Continue tummy time and start introducing toys. Monitor for developmental delays.",
    feedingInfo:
        "Feeding 6-8 times per day. May start to show interest in solid foods (but not ready yet).",
    sleepInfo:
        "Sleeping 11-14 hours per day. May start to sleep longer at night.",
    weight: "5.5-7.5 kg",
    height: "60-70 cm",
    headCircumference: "39-42 cm",
    milestones: [
      "Rolls from tummy to back",
      "Reaches for objects",
      "Brings objects to mouth",
      "Laughs and squeals",
      "Recognizes familiar people",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 4
  BabyDevelopmentData(
    month: 4,
    title: "4 Months Old",
    description:
        "Your baby is becoming more mobile and may start to roll in both directions!",
    physicalDevelopment:
        "Your baby can roll from back to tummy and may start to sit with support.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to respond to their name.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show stranger anxiety.",
    healthTips:
        "Continue tummy time and start introducing sitting practice. Monitor for developmental milestones.",
    feedingInfo:
        "Feeding 5-7 times per day. May start to show interest in solid foods.",
    sleepInfo:
        "Sleeping 10-13 hours per day. May start to sleep through the night.",
    weight: "6.5-8.5 kg",
    height: "65-75 cm",
    headCircumference: "41-44 cm",
    milestones: [
      "Rolls from back to tummy",
      "Sits with support",
      "Responds to name",
      "Shows stranger anxiety",
      "Reaches for objects with both hands",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 5
  BabyDevelopmentData(
    month: 5,
    title: "5 Months Old",
    description:
        "Your baby is becoming more independent and may start to sit without support!",
    physicalDevelopment:
        "Your baby can sit without support briefly and may start to rock on hands and knees.",
    cognitiveDevelopment:
        "Your baby understands cause and effect and may start to imitate sounds and gestures.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain people.",
    healthTips:
        "Continue tummy time and start introducing crawling practice. Monitor for developmental milestones.",
    feedingInfo:
        "Feeding 5-6 times per day. May be ready to start solid foods (consult your doctor).",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "7.5-9.5 kg",
    height: "70-80 cm",
    headCircumference: "42-45 cm",
    milestones: [
      "Sits without support briefly",
      "Rocks on hands and knees",
      "Imitates sounds and gestures",
      "Plays peek-a-boo",
      "Shows preferences for people",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 6
  BabyDevelopmentData(
    month: 6,
    title: "6 Months Old",
    description:
        "Your baby is ready to start solid foods and may begin crawling!",
    physicalDevelopment:
        "Your baby can sit without support and may start to crawl or scoot around.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to look for hidden objects.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show separation anxiety.",
    healthTips:
        "Start introducing solid foods (with doctor's approval). Continue tummy time and crawling practice.",
    feedingInfo:
        "Feeding 4-6 times per day plus solid foods. Start with iron-fortified cereals and pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "8.5-10.5 kg",
    height: "75-85 cm",
    headCircumference: "43-46 cm",
    milestones: [
      "Sits without support",
      "Starts to crawl or scoot",
      "Looks for hidden objects",
      "Shows separation anxiety",
      "Starts solid foods",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 7
  BabyDevelopmentData(
    month: 7,
    title: "7 Months Old",
    description:
        "Your baby is becoming more mobile and may start to pull up to stand!",
    physicalDevelopment:
        "Your baby can crawl and may start to pull up to stand. They may start to cruise along furniture.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to imitate actions and sounds.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain toys.",
    healthTips:
        "Continue tummy time and crawling practice. Start introducing more solid foods.",
    feedingInfo:
        "Feeding 4-5 times per day plus solid foods. Introduce a variety of pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "9.5-11.5 kg",
    height: "80-90 cm",
    headCircumference: "44-47 cm",
    milestones: [
      "Crawls efficiently",
      "Pulls up to stand",
      "Imitates actions and sounds",
      "Shows preferences for toys",
      "Starts to cruise along furniture",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 8
  BabyDevelopmentData(
    month: 8,
    title: "8 Months Old",
    description:
        "Your baby is becoming more independent and may start to wave goodbye!",
    physicalDevelopment:
        "Your baby can pull up to stand and may start to cruise along furniture. They may start to wave.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to imitate actions and sounds.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain people.",
    healthTips:
        "Continue tummy time and crawling practice. Start introducing more solid foods.",
    feedingInfo:
        "Feeding 4-5 times per day plus solid foods. Introduce a variety of pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "10.5-12.5 kg",
    height: "85-95 cm",
    headCircumference: "45-48 cm",
    milestones: [
      "Pulls up to stand",
      "Cruises along furniture",
      "Waves goodbye",
      "Imitates actions and sounds",
      "Shows preferences for people",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 9
  BabyDevelopmentData(
    month: 9,
    title: "9 Months Old",
    description:
        "Your baby is becoming more mobile and may start to take their first steps!",
    physicalDevelopment:
        "Your baby can cruise along furniture and may start to take their first steps.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to imitate actions and sounds.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain toys.",
    healthTips:
        "Continue tummy time and crawling practice. Start introducing more solid foods.",
    feedingInfo:
        "Feeding 4-5 times per day plus solid foods. Introduce a variety of pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "11.5-13.5 kg",
    height: "90-100 cm",
    headCircumference: "46-49 cm",
    milestones: [
      "Cruises along furniture",
      "Takes first steps",
      "Imitates actions and sounds",
      "Shows preferences for toys",
      "Starts to understand simple commands",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 10
  BabyDevelopmentData(
    month: 10,
    title: "10 Months Old",
    description:
        "Your baby is becoming more independent and may start to say their first words!",
    physicalDevelopment:
        "Your baby can take a few steps and may start to say their first words.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to imitate actions and sounds.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain people.",
    healthTips:
        "Continue tummy time and crawling practice. Start introducing more solid foods.",
    feedingInfo:
        "Feeding 4-5 times per day plus solid foods. Introduce a variety of pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "12.5-14.5 kg",
    height: "95-105 cm",
    headCircumference: "47-50 cm",
    milestones: [
      "Takes a few steps",
      "Says first words",
      "Imitates actions and sounds",
      "Shows preferences for people",
      "Starts to understand simple commands",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 11
  BabyDevelopmentData(
    month: 11,
    title: "11 Months Old",
    description:
        "Your baby is becoming more independent and may start to walk!",
    physicalDevelopment:
        "Your baby can take several steps and may start to walk independently.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to imitate actions and sounds.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain toys.",
    healthTips:
        "Continue tummy time and crawling practice. Start introducing more solid foods.",
    feedingInfo:
        "Feeding 4-5 times per day plus solid foods. Introduce a variety of pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "13.5-15.5 kg",
    height: "100-110 cm",
    headCircumference: "48-51 cm",
    milestones: [
      "Takes several steps",
      "Walks independently",
      "Imitates actions and sounds",
      "Shows preferences for toys",
      "Starts to understand simple commands",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Month 12
  BabyDevelopmentData(
    month: 12,
    title: "12 Months Old",
    description:
        "Happy Birthday! Your baby is now a toddler and may be walking independently!",
    physicalDevelopment:
        "Your baby can walk independently and may start to climb stairs.",
    cognitiveDevelopment:
        "Your baby understands object permanence and may start to imitate actions and sounds.",
    socialDevelopment:
        "Your baby enjoys playing with others and may start to show preferences for certain people.",
    healthTips:
        "Continue tummy time and crawling practice. Start introducing more solid foods.",
    feedingInfo:
        "Feeding 4-5 times per day plus solid foods. Introduce a variety of pureed foods.",
    sleepInfo:
        "Sleeping 10-12 hours per day. May have established a regular sleep schedule.",
    weight: "14.5-16.5 kg",
    height: "105-115 cm",
    headCircumference: "49-52 cm",
    milestones: [
      "Walks independently",
      "Climbs stairs",
      "Imitates actions and sounds",
      "Shows preferences for people",
      "Starts to understand simple commands",
    ],
    imageAsset: "assets/Safe/week1.jpg",
  ),

  // Continue with more months up to 24 months...
  // Month 13-24 would follow the same pattern with age-appropriate milestones
];
