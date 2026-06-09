import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _taskController = TextEditingController();
  final _goalController = TextEditingController();
  int _step = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _taskController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 1 && _nameController.text.trim().isNotEmpty) {
      setState(() => _step = 2);
    }
  }

  void _finishOnboarding() {
    final appState = context.read<AppState>();
    appState.setUserName(_nameController.text.trim());

    if (_taskController.text.trim().isNotEmpty) {
      appState.addTask(title: _taskController.text.trim());
    }

    if (_goalController.text.trim().isNotEmpty) {
      appState.addGoal(title: _goalController.text.trim());
    }

    appState.completeOnboarding();
  }

  Future<void> _openTextInputOverlay({
    required String title,
    required TextEditingController controller,
    required String hint,
    required String description,
  }) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Eingabe schließen',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: Theme.of(dialogContext).cardColor,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(description, style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(color: Theme.of(dialogContext).colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 18),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(labelText: hint),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('Abbrechen'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('Fertig'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNameSet = _nameController.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Willkommen bei FokusApp', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(
                _step == 1
                    ? 'Lass uns zuerst deinen Namen speichern. Du kannst ihn später in den Einstellungen ändern.'
                    : 'Fast geschafft! Tippe auf ein Feld, um es einzugeben. Nur das Feld erscheint oben, der Rest dunkelt ab.',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              if (_step == 1) ...[
                _InputTile(
                  label: 'Name',
                  value: _nameController.text.trim(),
                  placeholder: 'Gib deinen Namen ein',
                  onTap: () => _openTextInputOverlay(
                    title: 'Deinen Namen eingeben',
                    controller: _nameController,
                    hint: 'Dein Name',
                    description: 'Damit spricht dich die App persönlich an.',
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: isNameSet ? _nextStep : null,
                  child: const Text('Weiter'),
                ),
              ] else ...[
                _InputTile(
                  label: 'Aufgabe',
                  value: _taskController.text.trim(),
                  placeholder: 'Optionaler Fokusauftrag',
                  onTap: () => _openTextInputOverlay(
                    title: 'Aufgabe hinzufügen',
                    controller: _taskController,
                    hint: 'Aufgabe',
                    description: 'Schreibe eine Aufgabe, die dir hilft, motiviert zu starten.',
                  ),
                ),
                const SizedBox(height: 20),
                _InputTile(
                  label: 'Verzicht',
                  value: _goalController.text.trim(),
                  placeholder: 'Optionales Verzichtsziel',
                  onTap: () => _openTextInputOverlay(
                    title: 'Verzicht anlegen',
                    controller: _goalController,
                    hint: 'Verzichts-Ziel',
                    description: 'Notiere einen kleinen Verzicht, um deinen Fokus zu stärken.',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Du kannst Aufgabe und Verzicht auch überspringen und später jederzeit ergänzen.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text('Überspringen'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _finishOnboarding,
                      child: const Text('Fertig'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InputTile extends StatelessWidget {
  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  const _InputTile({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: theme.shadowColor.withAlpha(12), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              value.isEmpty ? placeholder : value,
              style: TextStyle(
                color: value.isEmpty ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tippe hier, um zu schreiben.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
