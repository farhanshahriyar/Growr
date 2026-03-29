import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryContainer.withOpacity(0.2),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      selectedIndex: _calculateSelectedIndex(context),
      onDestinationSelected: (int index) => _onItemTapped(index, context),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: AppColors.primary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon: Icon(Icons.restaurant, color: AppColors.primary),
          label: 'Meals',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center, color: AppColors.primary),
          label: 'Workout',
        ),
        NavigationDestination(
          icon: Icon(Icons.show_chart_outlined),
          selectedIcon: Icon(Icons.show_chart, color: AppColors.primary),
          label: 'Progress',
        ),
      ],
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/meals')) return 1;
    if (location.startsWith('/workout')) return 2;
    if (location.startsWith('/progress')) return 3;
    return 0; // Default
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/meals');
        break;
      case 2:
        context.go('/workout');
        break;
      case 3:
        context.go('/progress');
        break;
    }
  }
}
