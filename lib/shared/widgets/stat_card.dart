import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? trailing;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trailing,
    this.backgroundColor = AppColors.surfaceContainerLowest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.inverseSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
