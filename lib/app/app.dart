import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router.dart';

class GrowrApp extends StatelessWidget {
  const GrowrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Growr',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
    );
  }
}
