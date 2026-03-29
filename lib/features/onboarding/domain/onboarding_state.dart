class OnboardingState {
  final String name;
  final String goal; // lean_bulk, fat_loss, maintain
  final String budgetMode; // low, medium, flexible
  final String workoutMode; // home, gym
  final List<String> preferences;

  const OnboardingState({
    this.name = '',
    this.goal = '',
    this.budgetMode = '',
    this.workoutMode = '',
    this.preferences = const [],
  });

  OnboardingState copyWith({
    String? name,
    String? goal,
    String? budgetMode,
    String? workoutMode,
    List<String>? preferences,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      goal: goal ?? this.goal,
      budgetMode: budgetMode ?? this.budgetMode,
      workoutMode: workoutMode ?? this.workoutMode,
      preferences: preferences ?? this.preferences,
    );
  }

  bool get isGoalReady => goal.isNotEmpty;
  bool get isBudgetReady => budgetMode.isNotEmpty;
  bool get isWorkoutReady => workoutMode.isNotEmpty;
}
