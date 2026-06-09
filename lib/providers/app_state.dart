import 'package:flutter/foundation.dart';
import 'package:fokus_app_v2/models/abstinence_goal_model.dart';
import 'package:fokus_app_v2/models/task_model.dart';

class AppState extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(id: 't1', title: 'Morgens 5 Minuten Atemübung', completed: true, priority: TaskPriority.low),
    TaskModel(id: 't2', title: 'Inbox aufräumen', description: 'Alle neuen E-Mails kurz sichten', completed: false, priority: TaskPriority.medium),
    TaskModel(id: 't3', title: 'Pomodoro-Session starten', description: '25 Minuten konzentriert arbeiten', completed: false, priority: TaskPriority.high),
  ];

  final List<AbstinenceGoalModel> _goals = [
    AbstinenceGoalModel(id: 'g1', title: 'Heute kein Zucker', completedToday: true, currentStreak: 4, successCount: 7),
    AbstinenceGoalModel(id: 'g2', title: 'Keine Social-Media-Pause', completedToday: false, currentStreak: 1, successCount: 3),
  ];

  bool _dailyRemindersEnabled = false;
  bool _gentleAnimationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _privacyModeEnabled = true;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<AbstinenceGoalModel> get goals => List.unmodifiable(_goals);

  bool get dailyRemindersEnabled => _dailyRemindersEnabled;
  bool get gentleAnimationsEnabled => _gentleAnimationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get privacyModeEnabled => _privacyModeEnabled;

  double get taskCompletionRatio {
    if (_tasks.isEmpty) return 0.0;
    return _tasks.where((task) => task.completed).length / _tasks.length;
  }

  double get goalCompletionRatio {
    if (_goals.isEmpty) return 0.0;
    return _goals.where((goal) => goal.completedToday).length / _goals.length;
  }

  void addTask({required String title, String description = '', TaskPriority priority = TaskPriority.medium}) {
    final task = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      completed: false,
    );
    _tasks.insert(0, task);
    notifyListeners();
  }

  void updateTask(TaskModel newTask) {
    final index = _tasks.indexWhere((task) => task.id == newTask.id);
    if (index == -1) return;
    _tasks[index] = newTask;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTaskCompleted(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].toggleComplete();
    notifyListeners();
  }

  void addGoal({required String title, String description = ''}) {
    final goal = AbstinenceGoalModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      completedToday: false,
      currentStreak: 0,
      successCount: 0,
    );
    _goals.insert(0, goal);
    notifyListeners();
  }

  void toggleDailyReminders() {
    _dailyRemindersEnabled = !_dailyRemindersEnabled;
    notifyListeners();
  }

  void toggleGentleAnimations() {
    _gentleAnimationsEnabled = !_gentleAnimationsEnabled;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkModeEnabled = !_darkModeEnabled;
    notifyListeners();
  }

  void togglePrivacyMode() {
    _privacyModeEnabled = !_privacyModeEnabled;
    notifyListeners();
  }

  void updateGoal(AbstinenceGoalModel newGoal) {
    final index = _goals.indexWhere((goal) => goal.id == newGoal.id);
    if (index == -1) return;
    _goals[index] = newGoal;
    notifyListeners();
  }

  void deleteGoal(String id) {
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
  }

  void toggleGoalCompleted(String id) {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index == -1) return;
    final goal = _goals[index];
    _goals[index] = goal.toggleToday(success: !goal.completedToday);
    notifyListeners();
  }

  void resetAllDailyGoals() {
    for (var i = 0; i < _goals.length; i++) {
      _goals[i] = _goals[i].copyWith(completedToday: false);
    }
    notifyListeners();
  }
}
