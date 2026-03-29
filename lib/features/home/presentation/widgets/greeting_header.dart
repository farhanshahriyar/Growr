import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/application/profile_controller.dart';
import '../../../app/theme/app_colors.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final hour = DateTime.now().hour;
    String greeting = 'Good evening';
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    }

    final name = profile?.name ?? 'Builder';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.6),
                      ),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'G',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
