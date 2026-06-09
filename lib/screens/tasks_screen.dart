import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/models/task_model.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appState.tasks.isEmpty)
              _EmptyState(onTapAdd: () => _showTaskEditDialog(context))
            else
              Column(
                children: [
                  ...appState.tasks.map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TaskItem(task: task),
                      )),
                ],
              ),
            const SizedBox(height: 20),
            _ActionBar(onAdd: () => _showTaskEditDialog(context)),
          ],
        ),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TaskModel task;

  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = theme.cardColor;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final shadowColor = theme.shadowColor.withAlpha(16);

    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        decoration: BoxDecoration(color: colorScheme.error.withAlpha(31), borderRadius: BorderRadius.circular(24)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        child: Icon(Icons.delete_outline, color: colorScheme.error),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<AppState>().deleteTask(task.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _showTaskEditDialog(context, task: task),
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
                onTap: () => context.read<AppState>().toggleTaskCompleted(task.id),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: task.completed ? colorScheme.primary : colorScheme.onSurface.withAlpha(16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(task.completed ? Icons.check : Icons.circle_outlined, color: task.completed ? colorScheme.onPrimary : colorScheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(task.description, style: TextStyle(color: onSurfaceVariant, fontSize: 14)),
                    ],
                    const SizedBox(height: 8),
                    Text(getPriorityLabel(task.priority), style: TextStyle(color: onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

// Zusammengeführte Dialog-Funktion mit StatefulBuilder für korrektes Dropdown-Verhalten
void _showTaskEditDialog(BuildContext context, {TaskModel? task}) {
  final titleController = TextEditingController(text: task?.title ?? '');
  final descriptionController = TextEditingController(text: task?.description ?? '');
  var priority = task?.priority ?? TaskPriority.medium;

  showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(task == null ? 'Neue Aufgabe' : 'Aufgabe bearbeiten'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titel')),
                  const SizedBox(height: 12),
                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Beschreibung'), maxLines: 3),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TaskPriority>(
                    value: priority,
                    decoration: const InputDecoration(labelText: 'Priorität'),
                    items: TaskPriority.values.map((value) => DropdownMenuItem(value: value, child: Text(getPriorityLabel(value)))).toList(),
                    onChanged: (value) {
                      if (value != null) setDialogState(() => priority = value);
                    },
                  ),
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
                  if (task == null) {
                    appState.addTask(title: title, description: descriptionController.text.trim(), priority: priority);
                  } else {
                    appState.updateTask(task.copyWith(title: title, description: descriptionController.text.trim(), priority: priority));
                  }
                  Navigator.of(context).pop();
                },
                child: Text(task == null ? 'Hinzufügen' : 'Speichern'),
              ),
            ],
          );
        },
      );
    },
  );
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
              label: const Text('Aufgabe hinzufügen'),
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
          Icon(Icons.task_alt, size: 78, color: onSurfaceVariant.withAlpha(80)),
          const SizedBox(height: 16),
          Text('Noch keine Aufgaben', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Beginne mit einer klaren Aufgabe, die dich ins Rollen bringt.', textAlign: TextAlign.center, style: TextStyle(color: onSurfaceVariant)),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: onTapAdd, child: const Text('Neue Aufgabe erstellen')),
        ],
      ),
    );
  }
}
