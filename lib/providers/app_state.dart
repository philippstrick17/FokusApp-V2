import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  static const _tasksKey = 'app_tasks';
  static const _goalsKey = 'app_goals';
  static const _settingsKey = 'app_settings';

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

  AppState() {
    _loadCache();
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
    _persistState();
  }

  void updateTask(TaskModel newTask) {
    final index = _tasks.indexWhere((task) => task.id == newTask.id);
    if (index == -1) return;
    _tasks[index] = newTask;
    notifyListeners();
    _persistState();
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
    _persistState();
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
    _persistState();
  }

  void toggleDailyReminders() {
    _dailyRemindersEnabled = !_dailyRemindersEnabled;
    notifyListeners();
    _persistState();
  }

  void toggleGentleAnimations() {
    _gentleAnimationsEnabled = !_gentleAnimationsEnabled;
    notifyListeners();
    _persistState();
  }

  void toggleDarkMode() {
    _darkModeEnabled = !_darkModeEnabled;
    notifyListeners();
    _persistState();
  }

  void togglePrivacyMode() {
    _privacyModeEnabled = !_privacyModeEnabled;
    notifyListeners();
    _persistState();
  }

  void updateGoal(AbstinenceGoalModel newGoal) {
    final index = _goals.indexWhere((goal) => goal.id == newGoal.id);
    if (index == -1) return;
    _goals[index] = newGoal;
    notifyListeners();
    _persistState();
  }

  void deleteGoal(String id) {
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
    _persistState();
  }

  void toggleGoalCompleted(String id) {
    final index = _goals.indexWhere((goal) => goal.id == id);
    if (index == -1) return;
    final goal = _goals[index];
    _goals[index] = goal.toggleToday(success: !goal.completedToday);
    notifyListeners();
    _persistState();
  }

  void resetAllDailyGoals() {
    for (var i = 0; i < _goals.length; i++) {
      _goals[i] = _goals[i].copyWith(completedToday: false);
    }
    notifyListeners();
  }

  void resetAllProgress() {
    for (var i = 0; i < _tasks.length; i++) {
      _tasks[i] = _tasks[i].copyWith(completed: false);
    }
    for (var i = 0; i < _goals.length; i++) {
      _goals[i] = _goals[i].copyWith(completedToday: false, currentStreak: 0, successCount: 0);
    }
    notifyListeners();
    _persistState();
  }

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();

    final storedTasks = prefs.getString(_tasksKey);
    if (storedTasks != null) {
      try {
        final decoded = jsonDecode(storedTasks) as List<dynamic>;
        _tasks
          ..clear()
          ..addAll(decoded.map((item) => TaskModel.fromJson(item as Map<String, dynamic>)));
      } catch (_) {
        // ignore invalid cache
      }
    }

    final storedGoals = prefs.getString(_goalsKey);
    if (storedGoals != null) {
      try {
        final decoded = jsonDecode(storedGoals) as List<dynamic>;
        _goals
          ..clear()
          ..addAll(decoded.map((item) => AbstinenceGoalModel.fromJson(item as Map<String, dynamic>)));
      } catch (_) {
        // ignore invalid cache
      }
    }

    final storedSettings = prefs.getString(_settingsKey);
    if (storedSettings != null) {
      try {
        final decoded = jsonDecode(storedSettings) as Map<String, dynamic>;
        _dailyRemindersEnabled = decoded['dailyReminders'] as bool? ?? _dailyRemindersEnabled;
        _gentleAnimationsEnabled = decoded['gentleAnimations'] as bool? ?? _gentleAnimationsEnabled;
        _darkModeEnabled = decoded['darkMode'] as bool? ?? _darkModeEnabled;
        _privacyModeEnabled = decoded['privacyMode'] as bool? ?? _privacyModeEnabled;
      } catch (_) {
        // ignore invalid cache
      }
    }

    notifyListeners();
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, jsonEncode(_tasks.map((task) => task.toJson()).toList()));
    await prefs.setString(_goalsKey, jsonEncode(_goals.map((goal) => goal.toJson()).toList()));
    await prefs.setString(_settingsKey, jsonEncode({
      'dailyReminders': _dailyRemindersEnabled,
      'gentleAnimations': _gentleAnimationsEnabled,
      'darkMode': _darkModeEnabled,
      'privacyMode': _privacyModeEnabled,
    }));
  }
}
