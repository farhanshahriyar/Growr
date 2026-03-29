import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/home_controller.dart';
import 'widgets/greeting_header.dart';
import 'widgets/hydration_card.dart';
import 'widgets/workout_cta_card.dart';
import 'widgets/tip_card.dart';
import '../../../shared/widgets/stat_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Calories',
                        value: '${state.caloriesConsumed}',
                        subtitle: '/ ${state.calorieGoal} kcal',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Protein',
                        value: '${state.proteinConsumedG}g',
                        subtitle: '/ ${state.proteinGoalG}g',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              HydrationCard(
                loggedMl: state.waterLoggedMl,
                goalMl: state.waterGoalMl,
              ),
              const SizedBox(height: 24),

              WorkoutCtaCard(
                activeDay: state.activeWorkoutDay,
                isCompleted: state.workoutCompletedToday,
              ),
              const SizedBox(height: 24),

              TipCard(tip: state.tipOfTheDay),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
