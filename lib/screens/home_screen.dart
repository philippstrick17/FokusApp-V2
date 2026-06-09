import 'package:flutter/material.dart';
import 'package:fokus_app_v2/screens/abstinence_screen.dart';
import 'package:fokus_app_v2/screens/dashboard_screen.dart';
import 'package:fokus_app_v2/screens/settings_screen.dart';
import 'package:fokus_app_v2/screens/tasks_screen.dart';

enum FocusTab { dashboard, tasks, abstinence }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FocusTab _selectedTab = FocusTab.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton<FocusTab>(
                        icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onSurface, size: 28),
                        initialValue: _selectedTab,
                        tooltip: 'Seite auswählen',
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: FocusTab.dashboard, child: Text('Dashboard')),
                          const PopupMenuItem(value: FocusTab.tasks, child: Text('Aufgaben')),
                          const PopupMenuItem(value: FocusTab.abstinence, child: Text('Verzichte')),
                        ],
                        onSelected: (value) {
                          setState(() {
                            _selectedTab = value;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings_rounded, color: Theme.of(context).colorScheme.onSurface),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(_buildTabLabel(_selectedTab), style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text('Wähle deine Ansicht. Ruhig. Klar. Schnell.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildSelectedPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPage() {
    switch (_selectedTab) {
      case FocusTab.tasks:
        return const TasksScreen();
      case FocusTab.abstinence:
        return const AbstinenceScreen();
      case FocusTab.dashboard:
        return const DashboardScreen();
    }
  }

  String _buildTabLabel(FocusTab tab) {
    switch (tab) {
      case FocusTab.dashboard:
        return 'Dashboard';
      case FocusTab.tasks:
        return 'Aufgaben';
      case FocusTab.abstinence:
        return 'Verzichte';
    }
  }
}
