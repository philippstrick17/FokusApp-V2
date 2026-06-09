import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/models/abstinence_goal_model.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

class AbstinenceScreen extends StatelessWidget {
  const AbstinenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appState.goals.isEmpty)
              _EmptyState(onTapAdd: () => _showGoalDialog(context))
            else
              Column(
                children: [
                  ...appState.goals.map((goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GoalItem(goal: goal),
                      )),
                ],
              ),
            const SizedBox(height: 20),
            _ActionBar(onAdd: () => _showGoalDialog(context)),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context, {AbstinenceGoalModel? goal}) {
    final titleController = TextEditingController(text: goal?.title ?? '');
    final descriptionController = TextEditingController(text: goal?.description ?? '');

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(goal == null ? 'Neues Ziel' : 'Ziel bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titel')),
                const SizedBox(height: 12),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Beschreibung'), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) return;
                final appState = context.read<AppState>();
                if (goal == null) {
                  appState.addGoal(title: title, description: descriptionController.text.trim());
                } else {
                  appState.updateGoal(goal.copyWith(title: title, description: descriptionController.text.trim()));
                }
                Navigator.of(context).pop();
              },
              child: Text(goal == null ? 'Hinzufügen' : 'Speichern'),
            ),
          ],
        );
      },
    );
  }
}

class _GoalItem extends StatelessWidget {
  final AbstinenceGoalModel goal;

  const _GoalItem({required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = theme.cardColor;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final shadowColor = theme.shadowColor.withAlpha(16);

    return Dismissible(
      key: ValueKey(goal.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(color: colorScheme.error.withAlpha(31), borderRadius: BorderRadius.circular(24)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        child: Icon(Icons.delete_outline, color: colorScheme.error),
      ),
      onDismissed: (_) => context.read<AppState>().deleteGoal(goal.id),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.read<AppState>().toggleGoalCompleted(goal.id),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: goal.completedToday ? const Color(0xFF23C6A5) : const Color(0xFFFFC86E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(goal.completedToday ? Icons.thumb_up : Icons.hourglass_top, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(goal.description, style: TextStyle(color: onSurfaceVariant, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('Streak ${goal.currentStreak} • Erfolge ${goal.successCount}', style: TextStyle(color: onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colorScheme.onSurfaceVariant),
              onPressed: () => _showGoalDialog(context, goal: goal),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context, {required AbstinenceGoalModel goal}) {
    final titleController = TextEditingController(text: goal.title);
    final descriptionController = TextEditingController(text: goal.description);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ziel bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titel')),
                const SizedBox(height: 12),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Beschreibung'), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) return;
                context.read<AppState>().updateGoal(goal.copyWith(title: title, description: descriptionController.text.trim()));
                Navigator.of(context).pop();
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }
}

class _ActionBar extends StatelessWidget {
  final VoidCallback onAdd;

  const _ActionBar({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Neues Ziel'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onTapAdd;

  const _EmptyState({required this.onTapAdd});

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_moon, size: 78, color: onSurfaceVariant.withAlpha(80)),
          const SizedBox(height: 16),
          Text('Noch keine Verzichte', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Füge deine Impulsziele hinzu und markiere sie täglich als erledigt.', textAlign: TextAlign.center, style: TextStyle(color: onSurfaceVariant)),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: onTapAdd, child: const Text('Ziel erstellen')),
        ],
      ),
    );
  }
}
