import 'dart:convert';

class UserProfile {
  final String id;
  final String name;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String goal; // lean_bulk | maintain | fat_loss
  final String budgetMode; // low | medium | flexible
  final String workoutMode; // gym | home
  final int waterGoalMl;
  final int dailyCalorieGoal;
  final int dailyProteinGoalG;
  final List<String> foodPreferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    required this.goal,
    required this.budgetMode,
    required this.workoutMode,
    required this.waterGoalMl,
    required this.dailyCalorieGoal,
    required this.dailyProteinGoalG,
    required this.foodPreferences,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'budgetMode': budgetMode,
      'workoutMode': workoutMode,
      'waterGoalMl': waterGoalMl,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dailyProteinGoalG': dailyProteinGoalG,
      'foodPreferences': foodPreferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age']?.toInt(),
      gender: map['gender'],
      heightCm: map['heightCm']?.toDouble(),
      weightKg: map['weightKg']?.toDouble(),
      goal: map['goal'] ?? '',
      budgetMode: map['budgetMode'] ?? '',
      workoutMode: map['workoutMode'] ?? '',
      waterGoalMl: map['waterGoalMl']?.toInt() ?? 2500,
      dailyCalorieGoal: map['dailyCalorieGoal']?.toInt() ?? 2500,
      dailyProteinGoalG: map['dailyProteinGoalG']?.toInt() ?? 120,
      foodPreferences: List<String>.from(map['foodPreferences'] ?? []),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? goal,
    String? budgetMode,
    String? workoutMode,
    int? waterGoalMl,
    int? dailyCalorieGoal,
    int? dailyProteinGoalG,
    List<String>? foodPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      goal: goal ?? this.goal,
      budgetMode: budgetMode ?? this.budgetMode,
      workoutMode: workoutMode ?? this.workoutMode,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyProteinGoalG: dailyProteinGoalG ?? this.dailyProteinGoalG,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
