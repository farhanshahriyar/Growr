import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/primary_button.dart';
import '../application/onboarding_controller.dart';

class WelcomeStep extends ConsumerWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            'Welcome to Growr.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'The disciplined path to a lean bulk.\nTrack meals, complete workouts, and see progress without the noise.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Start Journey',
            onPressed: onNext,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
