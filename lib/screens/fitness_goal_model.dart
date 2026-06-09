class FitnessGoalModel {
  final String id;
  final String title;
  final int targetValue;
  final int currentValue;
  final String unit;

  FitnessGoalModel({
    required this.id,
    required this.title,
    required this.targetValue,
    this.currentValue = 0,
    this.unit = '',
  });

  FitnessGoalModel copyWith({
    String? id,
    String? title,
    int? targetValue,
    int? currentValue,
    String? unit,
  }) {
    return FitnessGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
    );
  }

  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'unit': unit,
    };
  }

  factory FitnessGoalModel.fromJson(Map<String, dynamic> json) {
    return FitnessGoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      targetValue: json['targetValue'] as int,
      currentValue: json['currentValue'] as int? ?? 0,
      unit: json['unit'] as String? ?? '',
    );
  }
}