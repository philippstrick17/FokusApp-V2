import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        title: Text('Einstellungen', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Personalisierung', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Tägliche Erinnerungen'),
                subtitle: const Text('Erinnere mich jeden Tag an einen kurzen Fokus-Check.'),
                value: appState.dailyRemindersEnabled,
                onChanged: (_) => appState.toggleDailyReminders(),
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 6),
              SwitchListTile(
                title: const Text('Sanfte Animationen'),
                subtitle: const Text('Zeige kleine Animationen für Fortschritt und Feedback.'),
                value: appState.gentleAnimationsEnabled,
                onChanged: (_) => appState.toggleGentleAnimations(),
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 6),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Nutze einen dunkleren App-Stil für ruhige Umgebungen.'),
                value: appState.darkModeEnabled,
                onChanged: (_) => appState.toggleDarkMode(),
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text('App', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Datenschutzmodus'),
                subtitle: const Text('Minimiere Datenspeicherung und Tracking in der App.'),
                value: appState.privacyModeEnabled,
                onChanged: (_) => appState.togglePrivacyMode(),
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 6),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tagesziele zurücksetzen'),
                subtitle: const Text('Setzt den Fortschritt für heute zurück und startet frisch.'),
                trailing: TextButton(
                  onPressed: () {
                    appState.resetAllDailyGoals();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tagesziele wurden zurückgesetzt.')),
                    );
                  },
                  child: const Text('Zurücksetzen'),
                ),
              ),
              const SizedBox(height: 6),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fortschritt zurücksetzen'),
                subtitle: const Text('Setzt alle Erfolge, Streaks und erledigten Aufgaben zurück.'),
                trailing: TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Fortschritt zurücksetzen'),
                          content: const Text('Bist du sicher? Dieser Vorgang setzt alle Aufgaben, Streaks und Erfolge zurück.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Abbrechen')),
                            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Zurücksetzen')),
                          ],
                        );
                      },
                    );
                    if (confirmed == true) {
                      appState.resetAllProgress();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Fortschritt wurde vollständig zurückgesetzt.')),
                      );
                    }
                  },
                  child: const Text('Zurücksetzen'),
                ),
              ),
              const SizedBox(height: 6),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Feedback senden'),
                subtitle: const Text('Teile uns mit, was dir hilft oder was wir verbessern können.'),
                trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface.withAlpha(153), size: 18),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback-Funktion ist aktuell vorbereitet.')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
