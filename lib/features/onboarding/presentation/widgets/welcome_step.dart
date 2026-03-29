import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/onboarding_controller.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../app/theme/app_colors.dart';

class WelcomeStep extends ConsumerWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.psychology_outlined, size: 64, color: AppColors.primary),
          const SizedBox(height: 32),
          Text(
            'Welcome to Growr.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.inverseSurface,
                  letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Discipline. Routine. Affordable growth for Bangladeshi men.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 48),
          TextField(
            onChanged: controller.updateName,
            decoration: InputDecoration(
              labelText: 'What is your name?',
              filled: true,
              fillColor: AppColors.surfaceContainerLowest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Next',
            onPressed: state.name.trim().isNotEmpty ? controller.nextStep : () {},
          ),
        ],
      ),
    );
  }
}
