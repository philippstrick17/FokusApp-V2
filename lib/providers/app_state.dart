import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fokus_app_v2/models/abstinence_goal_model.dart';
import 'package:fokus_app_v2/models/task_model.dart';
import 'package:fokus_app_v2/models/fitness_goal_model.dart';

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

  final List<FitnessGoalModel> _fitnessGoals = [
    FitnessGoalModel(id: 'f1', title: 'Schritte', targetValue: 6000, currentValue: 0, unit: 'Schritte'),
  ];

  bool _dailyRemindersEnabled = false;
  bool _gentleAnimationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _privacyModeEnabled = true;
  String _userName = '';
  bool _onboardingComplete = false;
  bool _initialized = false;
  DateTime? _lastResetDate;

  static const _tasksKey = 'app_tasks';
  static const _goalsKey = 'app_goals';
  static const _settingsKey = 'app_settings';
  static const _fitnessKey = 'app_fitness';
  static const _lastResetKey = 'app_last_reset';

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<AbstinenceGoalModel> get goals => List.unmodifiable(_goals);
  List<FitnessGoalModel> get fitnessGoals => List.unmodifiable(_fitnessGoals);

  bool get dailyRemindersEnabled => _dailyRemindersEnabled;
  bool get gentleAnimationsEnabled => _gentleAnimationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get privacyModeEnabled => _privacyModeEnabled;
  String get userName => _userName;
  bool get onboardingComplete => _onboardingComplete;
  bool get initialized => _initialized;

  double get taskCompletionRatio {
    if (_tasks.isEmpty) return 0.0;
    return _tasks.where((task) => task.completed).length / _tasks.length;
  }

  double get goalCompletionRatio {
    if (_goals.isEmpty) return 0.0;
    return _goals.where((goal) => goal.completedToday).length / _goals.length;
  }

  double get fitnessCompletionRatio {
    if (_fitnessGoals.isEmpty) return 0.0;
    double totalProgress = 0.0;
    for (var goal in _fitnessGoals) {
      totalProgress += goal.progress;
    }
    return totalProgress / _fitnessGoals.length;
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
    _persistState();
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

  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
    _persistState();
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
    _persistState();
  }

  Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _tasks
      ..clear()
      ..addAll([
        TaskModel(id: 't1', title: 'Morgens 5 Minuten Atemübung', completed: true, priority: TaskPriority.low),
        TaskModel(id: 't2', title: 'Inbox aufräumen', description: 'Alle neuen E-Mails kurz sichten', completed: false, priority: TaskPriority.medium),
        TaskModel(id: 't3', title: 'Pomodoro-Session starten', description: '25 Minuten konzentriert arbeiten', completed: false, priority: TaskPriority.high),
      ]);

    _goals
      ..clear()
      ..addAll([
        AbstinenceGoalModel(id: 'g1', title: 'Heute kein Zucker', completedToday: true, currentStreak: 4, successCount: 7),
        AbstinenceGoalModel(id: 'g2', title: 'Keine Social-Media-Pause', completedToday: false, currentStreak: 1, successCount: 3),
      ]);

    _fitnessGoals
      ..clear()
      ..addAll([
        FitnessGoalModel(id: 'f1', title: 'Schritte', targetValue: 6000, currentValue: 0, unit: 'Schritte'),
      ]);

    _dailyRemindersEnabled = false;
    _gentleAnimationsEnabled = true;
    _darkModeEnabled = false;
    _privacyModeEnabled = true;
    _userName = '';
    _onboardingComplete = false;
    _initialized = true;
    
    final now = DateTime.now();
    _lastResetDate = DateTime(now.year, now.month, now.day);

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
    _persistState();
  }

  void resetAllProgress() {
    for (var i = 0; i < _tasks.length; i++) {
      _tasks[i] = _tasks[i].copyWith(completed: false);
    }
    for (var i = 0; i < _goals.length; i++) {
      _goals[i] = _goals[i].copyWith(completedToday: false, currentStreak: 0, successCount: 0);
    }
    for (var i = 0; i < _fitnessGoals.length; i++) {
      _fitnessGoals[i] = _fitnessGoals[i].copyWith(currentValue: 0);
    }
    notifyListeners();
    _persistState();
  }

  void updateFitnessGoal(FitnessGoalModel newGoal) {
    final index = _fitnessGoals.indexWhere((g) => g.id == newGoal.id);
    if (index == -1) return;
    _fitnessGoals[index] = newGoal;
    notifyListeners();
    _persistState();
  }

  void addFitnessProgress(String id, int amount) {
    final index = _fitnessGoals.indexWhere((g) => g.id == id);
    if (index == -1) return;
    final goal = _fitnessGoals[index];
    _fitnessGoals[index] = goal.copyWith(currentValue: goal.currentValue + amount);
    notifyListeners();
    _persistState();
  }

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();

    final storedFitness = prefs.getString(_fitnessKey);
    if (storedFitness != null) {
      try {
        final decoded = jsonDecode(storedFitness) as List<dynamic>;
        _fitnessGoals
          ..clear()
          ..addAll(decoded.map((item) => FitnessGoalModel.fromJson(item as Map<String, dynamic>)));
      } catch (_) {}
    }

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
        _userName = decoded['userName'] as String? ?? _userName;
        _onboardingComplete = decoded['onboardingComplete'] as bool? ?? _onboardingComplete;
      } catch (_) {
        // ignore invalid cache
      }
    }

    final lastResetStr = prefs.getString(_lastResetKey);
    if (lastResetStr != null) {
      _lastResetDate = DateTime.tryParse(lastResetStr);
    }

    _checkAndResetDailyProgress();
    _initialized = true;
    notifyListeners();
  }

  void _checkAndResetDailyProgress() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastResetDate == null) {
      _lastResetDate = today;
      _persistState();
      return;
    }

    if (_lastResetDate!.isBefore(today)) {
      // Aufgaben zurücksetzen
      for (var i = 0; i < _tasks.length; i++) {
        _tasks[i] = _tasks[i].copyWith(completed: false);
      }

      // Verzichte zurücksetzen und Streaks prüfen
      final difference = today.difference(_lastResetDate!).inDays;
      for (var i = 0; i < _goals.length; i++) {
        final goal = _goals[i];
        // Wenn das Ziel gestern nicht erreicht wurde oder mehr als ein Tag vergangen ist, bricht der Streak
        int newStreak = (goal.completedToday && difference <= 1) ? goal.currentStreak : 0;
        _goals[i] = goal.copyWith(
          completedToday: false,
          currentStreak: newStreak,
        );
      }

      // Fitness zurücksetzen
      for (var i = 0; i < _fitnessGoals.length; i++) {
        _fitnessGoals[i] = _fitnessGoals[i].copyWith(currentValue: 0);
      }

      _lastResetDate = today;
      _persistState();
    }
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, jsonEncode(_tasks.map((task) => task.toJson()).toList()));
    await prefs.setString(_goalsKey, jsonEncode(_goals.map((goal) => goal.toJson()).toList()));
    await prefs.setString(_fitnessKey, jsonEncode(_fitnessGoals.map((goal) => goal.toJson()).toList()));
    await prefs.setString(_settingsKey, jsonEncode({
      'dailyReminders': _dailyRemindersEnabled,
      'gentleAnimations': _gentleAnimationsEnabled,
      'darkMode': _darkModeEnabled,
      'privacyMode': _privacyModeEnabled,
      'userName': _userName,
      'onboardingComplete': _onboardingComplete,
    }));
    if (_lastResetDate != null) {
      await prefs.setString(_lastResetKey, _lastResetDate!.toIso8601String());
    }
  }
}
