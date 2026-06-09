import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/models/task_model.dart';
import 'package:fokus_app_v2/models/abstinence_goal_model.dart';
import 'package:fokus_app_v2/providers/app_state.dart';
import 'package:fokus_app_v2/widgets/donut_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recentTasks = appState.tasks.take(3).toList();
    final recentGoals = appState.goals.take(2).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Fokus', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('Dein ruhiges Dashboard für klare Entscheidungen', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DonutChart(
                    progress: appState.taskCompletionRatio,
                    color: const Color(0xFF4C6FFF),
                    backgroundColor: const Color(0xFFE7EBFF),
                    label: 'Tagesaufgaben',
                    valueLabel: '${(appState.taskCompletionRatio * 100).round()}%',
                  ),
                  DonutChart(
                    progress: appState.goalCompletionRatio,
                    color: const Color(0xFF23C6A5),
                    backgroundColor: const Color(0xFFEAF8F4),
                    label: 'Verzichts-Ziele',
                    valueLabel: '${(appState.goalCompletionRatio * 100).round()}%',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(title: 'Heute', description: 'Kleiner Gewinn. Starker Fokus.'),
                      const SizedBox(height: 16),
                      ...recentTasks.map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TaskCard(task: task),
                          )),
                      if (recentTasks.isEmpty) ...[
                        const SizedBox(height: 20),
                        Center(child: Text('Noch keine Aufgaben. Füge eine in Aufgaben hinzu.', style: TextStyle(color: Colors.grey.shade600))),
                      ],
                      const SizedBox(height: 28),
                      const _SectionHeader(title: 'Verzichte', description: 'Status und Streak auf einen Blick.'),
                      const SizedBox(height: 16),
                      ...recentGoals.map((goal) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _GoalCard(goal: goal),
                          )),
                      if (recentGoals.isEmpty) ...[
                        const SizedBox(height: 20),
                        Center(child: Text('Noch keine Verzichts-Ziele. Lege eines in Verzichte an.', style: TextStyle(color: Colors.grey.shade600))),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String description;

  const _SectionHeader({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
        Icon(Icons.arrow_forward, color: Colors.grey.shade500),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: task.completed ? const Color(0xFF4C6FFF) : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(task.completed ? Icons.check : Icons.circle_outlined, color: task.completed ? Colors.white : Colors.grey.shade500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(task.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: task.priority == TaskPriority.high ? const Color(0xFFEF5B5B).withAlpha(31) : const Color(0xFF4C6FFF).withAlpha(31),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(getPriorityLabel(task.priority), style: TextStyle(color: task.priority == TaskPriority.high ? const Color(0xFFEF5B5B) : const Color(0xFF4C6FFF), fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final AbstinenceGoalModel goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: goal.completedToday ? const Color(0xFF23C6A5) : const Color(0xFFFFC86E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(goal.completedToday ? Icons.thumb_up : Icons.hourglass_top, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('Streak: ${goal.currentStreak} Tage · Erfolge: ${goal.successCount}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: goal.completedToday ? const Color(0xFF23C6A5).withAlpha(36) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(goal.completedToday ? 'Erledigt' : 'Offen', style: TextStyle(color: goal.completedToday ? const Color(0xFF23C6A5) : Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
