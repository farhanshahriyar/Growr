import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? action;

  const SectionTitle({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
