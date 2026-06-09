import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fokus_app_v2/screens/abstinence_screen.dart';
import 'package:fokus_app_v2/screens/dashboard_screen.dart';
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
                  Text('FokusApp', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text('Wähle deine Ansicht. Ruhig. Klar. Schnell.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
                  const SizedBox(height: 20),
                  CupertinoSlidingSegmentedControl<FocusTab>(
                    groupValue: _selectedTab,
                    thumbColor: Colors.white,
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.all(4),
                    children: const {
                      FocusTab.dashboard: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        child: Text('Dashboard'),
                      ),
                      FocusTab.tasks: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        child: Text('Aufgaben'),
                      ),
                      FocusTab.abstinence: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        child: Text('Verzichte'),
                      ),
                    },
                    onValueChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedTab = value;
                      });
                    },
                  ),
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
}
