import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/habits/presentation/habits_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/learning/presentation/learning_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/statistics/presentation/statistics_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const learning = '/learning';
  static const habits = '/habits';
  static const statistics = '/statistics';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _Shell(shell: shell),
        branches: [
          _branch(AppRoutes.home, const HomePage()),
          _branch(AppRoutes.learning, const LearningPage()),
          _branch(AppRoutes.habits, const HabitsPage()),
          _branch(AppRoutes.statistics, const StatisticsPage()),
          _branch(AppRoutes.settings, const SettingsPage()),
        ],
      ),
    ],
  );
});

StatefulShellBranch _branch(String path, Widget page) => StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (context, state) => page)],
    );

class _Shell extends StatelessWidget {
  const _Shell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: shell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.bolt_outlined), label: 'Enfoque'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Aprender'),
          NavigationDestination(icon: Icon(Icons.checklist_outlined), label: 'Hábitos'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.tune_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }
}
