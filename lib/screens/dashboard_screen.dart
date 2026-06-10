import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:fokus_app_v2/models/task_model.dart';
import 'package:fokus_app_v2/models/abstinence_goal_model.dart';
import 'package:fokus_app_v2/models/fitness_goal_model.dart';
import 'package:fokus_app_v2/providers/app_state.dart';
import 'package:fokus_app_v2/widgets/donut_chart.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(String destination) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerCelebration(bool completed, bool animationsEnabled) {
    // Nur feiern, wenn die Aufgabe abgeschlossen ist UND Animationen aktiviert sind
    if (!completed || !animationsEnabled) return;
    SystemSound.play(SystemSoundType.click);
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recentTasks = appState.tasks.take(3).toList();
    final recentGoals = appState.goals.take(2).toList();
    
    // Sicherer Zugriff auf das Schritteziel
    final fitnessGoals = appState.fitnessGoals;
    final stepGoal = fitnessGoals.isNotEmpty ? fitnessGoals.firstWhere((g) => g.id == 'f1') : null;

    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;
    final primaryColor = colorScheme.primary;
    const accentGreen = Color(0xFF23C6A5);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            minimum: const EdgeInsets.only(top: 16),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DonutChart(
                                      progress: appState.taskCompletionRatio,
                                      color: primaryColor,
                                      backgroundColor: primaryColor.withAlpha(28),
                                      label: '',
                                      valueLabel: '',
                                    ),
                                    Text(
                                      '${(appState.taskCompletionRatio * 100).round()}%',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Aufgaben',
                                  style: TextStyle(
                                    color: onSurface.withAlpha(160),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            // Der neue Wochen-Fokus Kreis
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DonutChart(
                                      progress: appState.weeklyTaskStreak / 7,
                                      color: const Color(0xFFFF8C00), // Orange/Flammenfarbe
                                      backgroundColor: const Color(0xFFFF8C00).withAlpha(28),
                                      label: '', // Wir setzen das interne Label leer...
                                      valueLabel: '', // Wir nutzen das Icon in der Mitte
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.local_fire_department, color: Color(0xFFFF8C00), size: 28),
                                        const SizedBox(height: 2), // Kleiner Abstand unter der Flamme
                                        Text('${appState.weeklyTaskStreak}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), // Auch hier angepasst für Konsistenz
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12), // ...und fügen hier den gewünschten Platz ein
                                Text(
                                  'Wochen-Fokus',
                                  style: TextStyle(
                                    color: onSurface.withAlpha(160),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DonutChart(
                                      progress: appState.goalCompletionRatio,
                                      color: accentGreen,
                                      backgroundColor: accentGreen.withAlpha(28),
                                      label: '',
                                      valueLabel: '',
                                    ),
                                    Text(
                                      '${(appState.goalCompletionRatio * 100).round()}%',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Verzichte',
                                  style: TextStyle(
                                    color: onSurface.withAlpha(160),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DonutChart(
                                      progress: appState.fitnessCompletionRatio,
                                      color: const Color(0xFF4C6FFF),
                                      backgroundColor: const Color(0xFF4C6FFF).withAlpha(28),
                                      label: '',
                                      valueLabel: '',
                                    ),
                                    Text(
                                      '${(appState.fitnessCompletionRatio * 100).round()}%',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Fitness',
                                  style: TextStyle(
                                    color: onSurface.withAlpha(160),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          title: 'Heute',
                          description: 'Kleiner Gewinn. Starker Fokus.',
                          onTap: () => widget.onNavigate('tasks'),
                        ),
                        const SizedBox(height: 16),
                        ...recentTasks.map((task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _TaskCard(task: task, onToggle: (completed) => _triggerCelebration(completed, appState.gentleAnimationsEnabled)),
                            )),
                        if (recentTasks.isEmpty) ...[
                          const SizedBox(height: 20),
                          Center(child: Text('Noch keine Aufgaben. Füge eine in Aufgaben hinzu.', style: TextStyle(color: onSurface.withAlpha(140)))),
                        ],
                        const SizedBox(height: 28),
                        _SectionHeader(
                          title: 'Verzichte',
                          description: 'Status und Streak auf einen Blick.',
                          onTap: () => widget.onNavigate('abstinence'),
                        ),
                        const SizedBox(height: 16),
                        ...recentGoals.map((goal) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _GoalCard(goal: goal, onToggle: (completed) => _triggerCelebration(completed, appState.gentleAnimationsEnabled)),
                            )),
                        if (recentGoals.isEmpty) ...[
                          const SizedBox(height: 20),
                          Center(child: Text('Noch keine Verzichts-Ziele. Lege eines in Verzichte an.', style: TextStyle(color: onSurface.withAlpha(140)))),
                        ],
                        const SizedBox(height: 28),
                        _SectionHeader(
                          title: 'Fitness',
                          description: 'Dein tägliches Aktivitätslevel.',
                          onTap: () => widget.onNavigate('fitness'),
                        ),
                        const SizedBox(height: 16),
                        if (stepGoal != null)
                          _FitnessSummaryCard(
                            goal: stepGoal,
                            onTap: () => widget.onNavigate('fitness'),
                          )
                        else
                          const Center(child: Text('Keine Fitnessdaten verfügbar.')),
                        const SizedBox(height: 32),
                        if (appState.consecutiveWeeksStreak > 0)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor.withAlpha(200), primaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.white, size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Meister-Streak', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                      Text(
                                        'Du hast ${appState.consecutiveWeeksStreak} Wochen in Folge alle Aufgaben geschafft!',
                                        style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 48),
                        Center(
                          child: Text(
                            'Hinweis: Dein Fortschritt wird täglich um 00:00 Uhr zurückgesetzt.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: onSurface.withAlpha(100),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.03,
              numberOfParticles: 12,
              gravity: 0.35,
              shouldLoop: false,
              colors: const [
                Color(0xFF4C6FFF),
                Color(0xFF23C6A5),
                Color(0xFFFFC86E),
                Color(0xFFEF5B5B),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FitnessSummaryCard extends StatelessWidget {
  final FitnessGoalModel goal;
  final VoidCallback onTap;

  const _FitnessSummaryCard({required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shadowColor = theme.shadowColor.withAlpha(16);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    '${goal.currentValue} / ${goal.targetValue} ${goal.unit}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
          ],
        ),
        Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: content,
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final void Function(bool completed) onToggle;

  const _TaskCard({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = Theme.of(context).cardColor;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final shadowColor = Theme.of(context).shadowColor.withAlpha(16);

    return InkWell(
      onTap: () {
        context.read<AppState>().toggleTaskCompleted(task.id);
        onToggle(!task.completed);
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: task.completed ? colorScheme.primary : colorScheme.onSurface.withAlpha(16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                task.completed ? Icons.check : Icons.circle_outlined,
                color: task.completed ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(task.description, style: TextStyle(color: onSurfaceVariant, fontSize: 14)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: task.priority == TaskPriority.high ? const Color(0xFFEF5B5B).withAlpha(31) : colorScheme.primary.withAlpha(31),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                getPriorityLabel(task.priority),
                style: TextStyle(
                  color: task.priority == TaskPriority.high ? const Color(0xFFEF5B5B) : colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final AbstinenceGoalModel goal;
  final void Function(bool completed) onToggle;

  const _GoalCard({required this.goal, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = Theme.of(context).cardColor;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final shadowColor = Theme.of(context).shadowColor.withAlpha(16);

    return InkWell(
      onTap: () {
        context.read<AppState>().toggleGoalCompleted(goal.id);
        onToggle(!goal.completedToday);
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(0, 8)),
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
                  Text('Streak: ${goal.currentStreak} Tage · Erfolge: ${goal.successCount}', style: TextStyle(color: onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: goal.completedToday ? const Color(0xFF23C6A5).withAlpha(36) : colorScheme.onSurface.withAlpha(12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                goal.completedToday ? 'Erledigt' : 'Offen',
                style: TextStyle(
                  color: goal.completedToday ? const Color(0xFF23C6A5) : onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
