import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/db/app_database.dart';
import '../../features/profile/domain/user_profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(databaseProvider));
});

class ProfileRepository {
  final AppDatabase _db;

  ProfileRepository(this._db);

  Stream<UserProfile?> watchProfile() {
    return (_db.select(_db.profiles)
          ..limit(1))
        .watchSingleOrNull()
        .map((entity) => entity != null
            ? UserProfile(
                id: entity.id,
                name: entity.name,
                primaryGoal: entity.primaryGoal,
                budgetMode: entity.budgetMode,
                workoutMode: entity.workoutMode,
                dailyCalorieGoal: entity.dailyCalorieGoal,
                dailyProteinGoalG: entity.dailyProteinGoalG,
                waterGoalMl: entity.waterGoalMl,
                createdAt: entity.createdAt,
                updatedAt: null,
                age: null,
                gender: null,
                heightCm: null,
                weightKg: null,
                foodPreferences: null,
              )
            : null);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final now = DateTime.now();

    await into(_db.profiles).insert(
      ProfilesCompanion.insert(
        id: profile.id,
        name: profile.name,
        primaryGoal: profile.primaryGoal,
        budgetMode: profile.budgetMode,
        workoutMode: profile.workoutMode,
        dailyCalorieGoal: profile.dailyCalorieGoal,
        dailyProteinGoalG: profile.dailyProteinGoalG,
        waterGoalMl: profile.waterGoalMl,
        createdAt: profile.createdAt,
      ),
      onConflict: DoUpdate(
        target: [_db.profiles.id],
        set: {
          _db.profiles.name: profile.name,
          _db.profiles.primaryGoal: profile.primaryGoal,
          _db.profiles.budgetMode: profile.budgetMode,
          _db.profiles.workoutMode: profile.workoutMode,
          _db.profiles.dailyCalorieGoal: profile.dailyCalorieGoal,
          _db.profiles.dailyProteinGoalG: profile.dailyProteinGoalG,
          _db.profiles.waterGoalMl: profile.waterGoalMl,
        },
      ),
    );
  }

  Future<void> clearProfile() async {
    await delete(_db.profiles).go();
  }
}
