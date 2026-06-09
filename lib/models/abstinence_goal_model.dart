class AbstinenceGoalModel {
  final String id;
  final String title;
  final String description;
  final bool active;
  final bool completedToday;
  final int currentStreak;
  final int successCount;
  final DateTime lastUpdated;

  AbstinenceGoalModel({
    required this.id,
    required this.title,
    this.description = '',
    this.active = true,
    this.completedToday = false,
    this.currentStreak = 0,
    this.successCount = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  AbstinenceGoalModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? active,
    bool? completedToday,
    int? currentStreak,
    int? successCount,
    DateTime? lastUpdated,
  }) {
    return AbstinenceGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      active: active ?? this.active,
      completedToday: completedToday ?? this.completedToday,
      currentStreak: currentStreak ?? this.currentStreak,
      successCount: successCount ?? this.successCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  AbstinenceGoalModel toggleToday({required bool success}) {
    final updatedStreak = success ? currentStreak + 1 : 0;
    return copyWith(
      completedToday: success,
      currentStreak: updatedStreak,
      successCount: success ? successCount + 1 : successCount,
      lastUpdated: DateTime.now(),
    );
  }

  double get progressValue {
    if (!active) return 0.0;
    return completedToday ? 1.0 : 0.2;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'active': active,
      'completedToday': completedToday,
      'currentStreak': currentStreak,
      'successCount': successCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory AbstinenceGoalModel.fromJson(Map<String, dynamic> json) {
    return AbstinenceGoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      active: json['active'] as bool? ?? true,
      completedToday: json['completedToday'] as bool? ?? false,
      currentStreak: json['currentStreak'] as int? ?? 0,
      successCount: json['successCount'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}
