import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/home_controller.dart';
import 'widgets/greeting_header.dart';
import 'widgets/hydration_card.dart';
import 'widgets/workout_cta_card.dart';
import 'widgets/tip_card.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../hydration/application/hydration_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _showAddWaterModal(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(hydrationControllerProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddWaterBottomSheet(
        onAdd: (amount) async {
          await controller.addWater(amount);
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
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
                onAdd: () => _showAddWaterModal(context, ref),
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

class _AddWaterBottomSheet extends StatelessWidget {
  final Function(int amountMl) onAdd;

  const _AddWaterBottomSheet({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      {'label': '1 glass (250ml)', 'amount': 250},
      {'label': '500ml', 'amount': 500},
      {'label': '1 liter (1000ml)', 'amount': 1000},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.inverseSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Add Water',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.inverseSurface,
            ),
          ),
          const SizedBox(height: 24),
          ...options.map((opt) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: PrimaryButton(
                  label: opt['label'] as String,
                  onPressed: () => onAdd(opt['amount'] as int),
                ),
              )),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
