import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/repositories/workout_repository.dart';

final weeklySummaryProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.watchWeeklySummary();
});

final weightHistoryProvider = StreamProvider.autoDispose<List<WeightLogEntity>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getWeightHistory();
});

final progressPhotosProvider = StreamProvider.autoDispose<List<ProgressPhotoEntity>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getProgressPhotos();
});

final weeklyWorkoutStatsProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.watchWeeklyWorkoutStats();
});

final progressControllerProvider = Provider<ProgressController>((ref) {
  return ProgressController(
    ref.watch(progressRepositoryProvider),
    ref.watch(workoutRepositoryProvider),
  );
});

class ProgressController {
  final ProgressRepository _progressRepo;
  final WorkoutRepository _workoutRepo;

  ProgressController(this._progressRepo, this._workoutRepo);

  Future<void> logWeight(double weightKg) async {
    await _progressRepo.logWeight(weightKg);
  }

  Future<void> logProgressPhoto(String type, String uri) async {
    await _progressRepo.logProgressPhoto(type, uri);
  }
}
