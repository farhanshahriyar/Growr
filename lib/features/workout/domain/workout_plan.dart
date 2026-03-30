class WorkoutPlanEntity {
  final String id;
  final String name;
  final int day;
  final String title;
  final int durationMin;

  const WorkoutPlanEntity({
    required this.id,
    required this.name,
    required this.day,
    required this.title,
    required this.durationMin,
  });
}

class WorkoutExerciseEntity {
  final String id;
  final String planId;
  final String name;
  final int sets;
  final String repRange;
  final int? defaultRestSec;

  const WorkoutExerciseEntity({
    required this.id,
    required this.planId,
    required this.name,
    required this.sets,
    required this.repRange,
    this.defaultRestSec,
  });
}
