class UserProfile {
  final String id;
  final String name;
  final String primaryGoal; 
  final String budgetMode; // low, medium, high
  final String workoutMode; // home, gym
  final int dailyCalorieGoal;
  final int dailyProteinGoalG;
  final int waterGoalMl;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.primaryGoal,
    required this.budgetMode,
    required this.workoutMode,
    required this.dailyCalorieGoal,
    required this.dailyProteinGoalG,
    required this.waterGoalMl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryGoal': primaryGoal,
      'budgetMode': budgetMode,
      'workoutMode': workoutMode,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dailyProteinGoalG': dailyProteinGoalG,
      'waterGoalMl': waterGoalMl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      primaryGoal: json['primaryGoal'],
      budgetMode: json['budgetMode'],
      workoutMode: json['workoutMode'],
      dailyCalorieGoal: json['dailyCalorieGoal'],
      dailyProteinGoalG: json['dailyProteinGoalG'],
      waterGoalMl: json['waterGoalMl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
