import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class TipCard extends StatelessWidget {
  final String tip;

  const TipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.tertiaryFixed.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.inverseSurface.withOpacity(0.9),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
