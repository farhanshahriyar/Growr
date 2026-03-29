import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/welcome_step.dart';
import 'widgets/goal_step.dart';
import 'widgets/budget_mode_step.dart';
import 'widgets/workout_mode_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          children: [
            WelcomeStep(onNext: _nextPage),
            GoalStep(onNext: _nextPage),
            BudgetModeStep(onNext: _nextPage),
            WorkoutModeStep(onNext: _finish),
          ],
        ),
      ),
    );
  }
}
