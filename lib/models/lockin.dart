class LockIn {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final int currentDay;
  final String frequency;
  final bool isActive;
  final double punishmentAmount;
  final String punishmentBeneficiary;
  final int streak;
  final double successRate;
  final int missedDays;

  LockIn({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.currentDay,
    required this.frequency,
    required this.isActive,
    required this.punishmentAmount,
    required this.punishmentBeneficiary,
    required this.streak,
    required this.successRate,
    required this.missedDays,
  });

  factory LockIn.fromJson(Map<String, dynamic> json) {
    return LockIn(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalDays: json['totalDays'],
      currentDay: json['currentDay'],
      frequency: json['frequency'],
      isActive: json['isActive'],
      punishmentAmount: json['punishmentAmount'].toDouble(),
      punishmentBeneficiary: json['punishmentBeneficiary'],
      streak: json['streak'],
      successRate: json['successRate'].toDouble(),
      missedDays: json['missedDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalDays': totalDays,
      'currentDay': currentDay,
      'frequency': frequency,
      'isActive': isActive,
      'punishmentAmount': punishmentAmount,
      'punishmentBeneficiary': punishmentBeneficiary,
      'streak': streak,
      'successRate': successRate,
      'missedDays': missedDays,
    };
  }

  double get progressPercentage => currentDay / totalDays;
  int get remainingDays => totalDays - currentDay;
}