import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'features/profile/application/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Synchronous initialization of SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const GrowrApp(),
    ),
  );
}
