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
  final DateTime? updatedAt;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final List<String>? foodPreferences;

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
    this.updatedAt,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.foodPreferences,
  });

  UserProfile copyWith({
    String? name,
    String? primaryGoal,
    String? budgetMode,
    String? workoutMode,
    int? dailyCalorieGoal,
    int? dailyProteinGoalG,
    int? waterGoalMl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    List<String>? foodPreferences,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      budgetMode: budgetMode ?? this.budgetMode,
      workoutMode: workoutMode ?? this.workoutMode,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyProteinGoalG: dailyProteinGoalG ?? this.dailyProteinGoalG,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      foodPreferences: foodPreferences ?? this.foodPreferences,
    );
  }

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
      'updatedAt': updatedAt?.toIso8601String(),
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'foodPreferences': foodPreferences,
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
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      age: json['age'],
      gender: json['gender'],
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      foodPreferences: json['foodPreferences'] != null
          ? List<String>.from(json['foodPreferences'])
          : null,
    );
  }
}
