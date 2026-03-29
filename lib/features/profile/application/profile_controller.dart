import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user_profile.dart';

// Provides sync access to SharedPreferences across the app
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart first');
});

final profileControllerProvider = NotifierProvider<ProfileController, UserProfile?>(() {
  return ProfileController();
});

class ProfileController extends Notifier<UserProfile?> {
  static const _profileKey = 'local_user_profile';

  @override
  UserProfile? build() {
    return _loadProfile();
  }

  UserProfile? _loadProfile() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final jsonStr = prefs.getString(_profileKey);
    if (jsonStr != null) {
      try {
        return UserProfile.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final jsonStr = jsonEncode(profile.toJson());
    await prefs.setString(_profileKey, jsonStr);
    state = profile; // Notifies listeners
  }

  Future<void> clearProfile() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_profileKey);
    state = null;
  }
}
