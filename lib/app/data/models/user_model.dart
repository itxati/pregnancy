class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? password; // Only stored during signup, not for security
  final DateTime createdAt;
  final bool isLoggedIn;
  final String? profileImagePath;
  final String? babyBloodGroup;
  final String? motherBloodGroup;
  final String? relation;
  final DateTime? babyBirthDate;

  // Fertility tracking data
  final DateTime? lastPeriodStart;
  final int cycleLength;
  final int periodLength;
  final List<DateTime> intercourseLog;

  // Pregnancy tracking data
  final DateTime? dueDate;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.password,
    required this.createdAt,
    this.isLoggedIn = false,
    this.profileImagePath,
    this.babyBloodGroup,
    this.motherBloodGroup,
    this.relation,
    this.babyBirthDate,
    this.lastPeriodStart,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.intercourseLog = const [],
    this.dueDate,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isLoggedIn': isLoggedIn,
      'profileImagePath': profileImagePath,
      'babyBloodGroup': babyBloodGroup,
      'motherBloodGroup': motherBloodGroup,
      'relation': relation,
      'babyBirthDate': babyBirthDate?.millisecondsSinceEpoch,
      'lastPeriodStart': lastPeriodStart?.millisecondsSinceEpoch,
      'cycleLength': cycleLength,
      'periodLength': periodLength,
      'intercourseLog':
          intercourseLog.map((date) => date.millisecondsSinceEpoch).toList(),
      'dueDate': dueDate?.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      isLoggedIn: json['isLoggedIn'] ?? false,
      profileImagePath: json['profileImagePath'],
      babyBloodGroup: json['babyBloodGroup'],
      motherBloodGroup: json['motherBloodGroup'],
      relation: json['relation'],
      babyBirthDate: json['babyBirthDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['babyBirthDate'])
          : null,
      lastPeriodStart: json['lastPeriodStart'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPeriodStart'])
          : null,
      cycleLength: json['cycleLength'] ?? 28,
      periodLength: json['periodLength'] ?? 5,
      intercourseLog: json['intercourseLog'] != null
          ? (json['intercourseLog'] as List)
              .map(
                  (timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp))
              .toList()
          : [],
      dueDate: json['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'])
          : null,
    );
  }

  // Create a copy with updated values
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    DateTime? createdAt,
    bool? isLoggedIn,
    String? profileImagePath,
    String? babyBloodGroup,
    String? motherBloodGroup,
    String? relation,
    DateTime? babyBirthDate,
    DateTime? lastPeriodStart,
    int? cycleLength,
    int? periodLength,
    List<DateTime>? intercourseLog,
    DateTime? dueDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      babyBloodGroup: babyBloodGroup ?? this.babyBloodGroup,
      motherBloodGroup: motherBloodGroup ?? this.motherBloodGroup,
      relation: relation ?? this.relation,
      babyBirthDate: babyBirthDate ?? this.babyBirthDate,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      intercourseLog: intercourseLog ?? this.intercourseLog,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
