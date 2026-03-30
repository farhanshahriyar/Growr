class LoggedExerciseEntity {
  final String id;
  final String sessionId;
  final String exerciseId;

  const LoggedExerciseEntity({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
  });
}

class LoggedSetEntity {
  final String id;
  final String loggedExerciseId;
  final int setNo;
  final int reps;
  final double? weightKg;
  final bool done;

  const LoggedSetEntity({
    required this.id,
    required this.loggedExerciseId,
    required this.setNo,
    required this.reps,
    this.weightKg,
    required this.done,
  });
}
