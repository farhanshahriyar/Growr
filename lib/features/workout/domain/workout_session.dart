class WorkoutSessionEntity {
  final String id;
  final String planId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool completed;

  const WorkoutSessionEntity({
    required this.id,
    required this.planId,
    required this.startedAt,
    this.endedAt,
    required this.completed,
  });
}
