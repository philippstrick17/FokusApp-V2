import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fokus_app_v2/screens/abstinence_screen.dart';
import 'package:fokus_app_v2/screens/dashboard_screen.dart';
import 'package:fokus_app_v2/screens/settings_screen.dart';
import 'package:fokus_app_v2/screens/tasks_screen.dart';
import 'package:fokus_app_v2/screens/fitness_screen.dart';
import 'package:fokus_app_v2/providers/app_state.dart';

enum FocusTab { dashboard, tasks, abstinence, fitness }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusTab _selectedTab = FocusTab.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Navigation', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface),
                      tooltip: 'Schließen',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DrawerItem(
                  label: 'Dashboard',
                  selected: _selectedTab == FocusTab.dashboard,
                  onTap: () {
                    setState(() => _selectedTab = FocusTab.dashboard);
                    Navigator.of(context).pop();
                  },
                ),
                _DrawerItem(
                  label: 'Aufgaben',
                  selected: _selectedTab == FocusTab.tasks,
                  onTap: () {
                    setState(() => _selectedTab = FocusTab.tasks);
                    Navigator.of(context).pop();
                  },
                ),
                _DrawerItem(
                  label: 'Verzichte',
                  selected: _selectedTab == FocusTab.abstinence,
                  onTap: () {
                    setState(() => _selectedTab = FocusTab.abstinence);
                    Navigator.of(context).pop();
                  },
                ),
                _DrawerItem(
                  label: 'Fitness',
                  selected: _selectedTab == FocusTab.fitness,
                  onTap: () {
                    setState(() => _selectedTab = FocusTab.fitness);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 16),
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
                      IconButton(
                        icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onSurface, size: 28),
                        tooltip: 'Seite auswählen',
                        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                  Text(
                    'Hallo ${context.watch<AppState>().userName.isEmpty ? 'Fokus' : context.watch<AppState>().userName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(_buildTabLabel(_selectedTab), style: Theme.of(context).textTheme.headlineSmall),
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
      case FocusTab.fitness:
        return const FitnessScreen();
      case FocusTab.dashboard:
        return DashboardScreen(
          onNavigate: (destination) {
            if (destination == 'tasks') {
              setState(() => _selectedTab = FocusTab.tasks);
            } else if (destination == 'abstinence') {
              setState(() => _selectedTab = FocusTab.abstinence);
            } else if (destination == 'fitness') {
              setState(() => _selectedTab = FocusTab.fitness);
            }
          },
        );
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
      case FocusTab.fitness:
        return 'Fitness';
    }
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.primary.withAlpha(31) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (selected) Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
