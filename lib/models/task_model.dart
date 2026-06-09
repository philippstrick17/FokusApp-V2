enum TaskPriority { low, medium, high }

String getPriorityLabel(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return 'LOW';
    case TaskPriority.medium:
      return 'MEDIUM';
    case TaskPriority.high:
      return 'HIGH';
  }
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool completed;
  final TaskPriority priority;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    DateTime? createdAt,
    this.dueDate,
    this.completed = false,
    this.priority = TaskPriority.medium,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? completed,
    TaskPriority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
    );
  }

  TaskModel toggleComplete() {
    return copyWith(completed: !completed);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'priority': priority.toString().split('.').last,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final priorityValue = json['priority'] as String?;
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      completed: json['completed'] as bool? ?? false,
      priority: TaskPriority.values.firstWhere(
        (value) => value.toString().split('.').last == priorityValue,
        orElse: () => TaskPriority.medium,
      ),
    );
  }
}
