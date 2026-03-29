import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/meals/presentation/screens/meals_screen.dart';
import '../features/workout/presentation/screens/workout_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/profile/application/profile_controller.dart';
import '../shared/widgets/bottom_nav.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final profileState = ref.watch(profileControllerProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      // Guard: If there is no UserProfile, force them to onboarding
      final isGoingToOnboarding = state.uri.path == '/onboarding';
      
      if (profileState == null && !isGoingToOnboarding) {
        return '/onboarding';
      }

      // If they finished Onboarding but are still on the screen, bump them to home
      if (profileState != null && isGoingToOnboarding) {
        return '/home';
      }

      return null; // Return null implicitly allows the route
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
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
});
