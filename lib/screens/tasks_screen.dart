import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/models/task_model.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aufgaben', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text('Erstelle, bearbeite und erledige Aufgaben ohne Ablenkung.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
          const SizedBox(height: 20),
          Expanded(
            child: appState.tasks.isEmpty
                ? _EmptyState(onTapAdd: () => _showTaskDialog(context))
                : ListView.separated(
                    itemCount: appState.tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = appState.tasks[index];
                      return _TaskItem(task: task);
                    },
                  ),
          ),
          _ActionBar(onAdd: () => _showTaskDialog(context)),
        ],
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {TaskModel? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');
    var priority = task?.priority ?? TaskPriority.medium;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Neue Aufgabe' : 'Aufgabe bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Titel'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Beschreibung'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: 'Priorität'),
                  items: TaskPriority.values.map((value) {
                    return DropdownMenuItem(value: value, child: Text(getPriorityLabel(value)));
                  }).toList(),
                  onChanged: (value) => priority = value ?? TaskPriority.medium,
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
                  appState.updateTask(task.copyWith(
                    title: title,
                    description: descriptionController.text.trim(),
                    priority: priority,
                  ));
                }
                Navigator.of(context).pop();
              },
              child: Text(task == null ? 'Hinzufügen' : 'Speichern'),
            ),
          ],
        );
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TaskModel task;

  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(24)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        child: Icon(Icons.delete_outline, color: Colors.red.shade700),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<AppState>().deleteTask(task.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _showTaskDialog(context, task: task),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.read<AppState>().toggleTaskCompleted(task.id),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: task.completed ? const Color(0xFF4C6FFF) : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(task.completed ? Icons.check : Icons.circle_outlined, color: task.completed ? Colors.white : Colors.grey.shade500),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(task.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                    const SizedBox(height: 8),
                    Text(getPriorityLabel(task.priority), style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {required TaskModel task}) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    var priority = task.priority;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Aufgabe bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titel')),
                const SizedBox(height: 12),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Beschreibung'), maxLines: 3),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: 'Priorität'),
                  items: TaskPriority.values.map((value) => DropdownMenuItem(value: value, child: Text(getPriorityLabel(value)))).toList(),
                  onChanged: (value) => priority = value ?? TaskPriority.medium,
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
                context.read<AppState>().updateTask(task.copyWith(
                      title: title,
                      description: descriptionController.text.trim(),
                      priority: priority,
                    ));
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 78, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Noch keine Aufgaben', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Beginne mit einer klaren Aufgabe, die dich ins Rollen bringt.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: onTapAdd, child: const Text('Neue Aufgabe erstellen')),
        ],
      ),
    );
  }
}
