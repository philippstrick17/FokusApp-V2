import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/models/fitness_goal_model.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...appState.fitnessGoals.map((goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FitnessGoalCard(goal: goal),
                )),
          ],
        ),
      ),
    );
  }
}

class _FitnessGoalCard extends StatelessWidget {
  final FitnessGoalModel goal;

  const _FitnessGoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shadowColor = theme.shadowColor.withAlpha(16);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4C6FFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.directions_walk, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  Text('${goal.targetValue} ${goal.unit} als Ziel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${goal.currentValue} ${goal.unit}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF4C6FFF))),
              Text('${(goal.progress * 100).round()}%', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 12,
              backgroundColor: const Color(0xFF4C6FFF).withAlpha(30),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4C6FFF)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddProgressDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Fortschritt hinzufügen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C6FFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProgressDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schritte hinzufügen'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Anzahl der Schritte'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? 0;
              if (val > 0) {
                context.read<AppState>().addFitnessProgress(goal.id, val);
              }
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}