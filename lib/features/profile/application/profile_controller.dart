import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/profile_repository.dart';
import '../domain/user_profile.dart';

// Stream provider that watches profile changes from repository
final profileProvider = StreamProvider<UserProfile?>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.watchProfile();
});

// Controller for profile actions (save, clear)
final profileControllerProvider = NotifierProvider<ProfileController, void>(() {
  return ProfileController();
});

class ProfileController extends Notifier<void> {
  @override
  void build() {}

  Future<void> saveProfile(UserProfile profile) async {
    final repository = ref.read(profileRepositoryProvider);
    await repository.saveProfile(profile);
  }

  Future<void> clearProfile() async {
    final repository = ref.read(profileRepositoryProvider);
    await repository.clearProfile();
  }
}
