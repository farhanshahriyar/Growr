class HomeSummaryState {
  final int caloriesConsumed;
  final int calorieGoal;
  final int proteinConsumedG;
  final int proteinGoalG;
  final int waterLoggedMl;
  final int waterGoalMl;
  final String activeWorkoutDay;
  final bool workoutCompletedToday;
  final String tipOfTheDay;

  const HomeSummaryState({
    required this.caloriesConsumed,
    required this.calorieGoal,
    required this.proteinConsumedG,
    required this.proteinGoalG,
    required this.waterLoggedMl,
    required this.waterGoalMl,
    required this.activeWorkoutDay,
    required this.workoutCompletedToday,
    required this.tipOfTheDay,
  });

  HomeSummaryState copyWith({
    int? caloriesConsumed,
    int? calorieGoal,
    int? proteinConsumedG,
    int? proteinGoalG,
    int? waterLoggedMl,
    int? waterGoalMl,
    String? activeWorkoutDay,
    bool? workoutCompletedToday,
    String? tipOfTheDay,
  }) {
    return HomeSummaryState(
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinConsumedG: proteinConsumedG ?? this.proteinConsumedG,
      proteinGoalG: proteinGoalG ?? this.proteinGoalG,
      waterLoggedMl: waterLoggedMl ?? this.waterLoggedMl,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      activeWorkoutDay: activeWorkoutDay ?? this.activeWorkoutDay,
      workoutCompletedToday: workoutCompletedToday ?? this.workoutCompletedToday,
      tipOfTheDay: tipOfTheDay ?? this.tipOfTheDay,
    );
  }
}
