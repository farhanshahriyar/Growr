import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/meals/presentation/screens/meals_screen.dart';
import '../features/workout/presentation/screens/workout_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../shared/widgets/bottom_nav.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/meals',
          builder: (context, state) => const MealsScreen(),
        ),
        GoRoute(
          path: '/workout',
          builder: (context, state) => const WorkoutScreen(),
        ),
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressScreen(),
        ),
      ],
    ),
  ],
);
