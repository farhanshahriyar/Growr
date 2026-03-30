import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/hydration_repository.dart';

// Provider exposing today's total water intake in ml
final todayHydrationMlProvider = StreamProvider.autoDispose<int>((ref) {
  final repo = ref.watch(hydrationRepositoryProvider);
  return repo.watchTodaysWaterMl();
});

// Controller for hydration actions
final hydrationControllerProvider = Provider<HydrationController>((ref) {
  return HydrationController(ref.watch(hydrationRepositoryProvider));
});

class HydrationController {
  final HydrationRepository _repo;

  HydrationController(this._repo);

  Future<void> addWater(int amountMl) async {
    await _repo.logWater(amountMl);
  }
}
