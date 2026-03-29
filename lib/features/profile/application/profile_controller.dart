import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/domain/user_profile.dart';

// Provides the SharedPreferences instance synchronously (must be initialized in main())
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main() with ProviderScope(overrides: [...])');
});

final profileControllerProvider = NotifierProvider<ProfileController, UserProfile?>(() {
  return ProfileController();
});

class ProfileController extends Notifier<UserProfile?> {
  static const _profileKey = 'user_profile';

  @override
  UserProfile? build() {
    return _loadProfile();
  }

  UserProfile? _loadProfile() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final profileJson = prefs.getString(_profileKey);
    if (profileJson != null) {
      try {
        return UserProfile.fromJson(profileJson);
      } catch (e) {
        // Fallback if corruption occurs
        return null;
      }
    }
    return null;
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_profileKey, profile.toJson());
    state = profile;
  }

  Future<void> clearProfile() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_profileKey);
    state = null;
  }
}
