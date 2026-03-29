class OnboardingState {
  final int currentStep;
  final String name;
  final String primaryGoal;
  final String budgetMode;
  final String workoutMode;
  final bool isSubmitting;

  const OnboardingState({
    this.currentStep = 0,
    this.name = '',
    this.primaryGoal = 'lean_bulk',
    this.budgetMode = 'low',
    this.workoutMode = 'home',
    this.isSubmitting = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    String? name,
    String? primaryGoal,
    String? budgetMode,
    String? workoutMode,
    bool? isSubmitting,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      budgetMode: budgetMode ?? this.budgetMode,
      workoutMode: workoutMode ?? this.workoutMode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
