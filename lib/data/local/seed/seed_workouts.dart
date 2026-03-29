import 'package:uuid/uuid.dart';

class SeedWorkouts {
  static List<WorkoutPlanCompanion> getDefaultPlans() {
    final uuid = Uuid();

    return [
      WorkoutPlansCompanion.insert(
        id: uuid.v4(),
        name: 'Day 1 - Chest & Triceps',
        day: 1,
        title: 'Upper Body Push',
        durationMin: 45,
      ),
      WorkoutPlansCompanion.insert(
        id: uuid.v4(),
        name: 'Day 2 - Back & Biceps',
        day: 2,
        title: 'Upper Body Pull',
        durationMin: 45,
      ),
      WorkoutPlansCompanion.insert(
        id: uuid.v4(),
        name: 'Day 3 - Legs',
        day: 3,
        title: 'Lower Body',
        durationMin: 50,
      ),
      WorkoutPlansCompanion.insert(
        id: uuid.v4(),
        name: 'Day 4 - Shoulders',
        day: 4,
        title: 'Upper Body Isolations',
        durationMin: 40,
      ),
      WorkoutPlansCompanion.insert(
        id: uuid.v4(),
        name: 'Day 5 - Full Body',
        day: 5,
        title: 'Compound Focus',
        durationMin: 45,
      ),
    ];
  }

  static List<WorkoutExerciseCompanion> getDefaultExercises(List<String> planIds) {
    final uuid = Uuid();

    return [
      // Day 1 - Chest & Triceps (planIds[0])
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[0],
        name: 'Push-ups',
        sets: 4,
        repRange: '8-12',
        defaultRestSec: 60,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[0],
        name: 'Dumbbell Bench Press',
        sets: 4,
        repRange: '8-12',
        defaultRestSec: 90,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[0],
        name: 'Tricep Dips',
        sets: 3,
        repRange: '10-15',
        defaultRestSec: 45,
      ),

      // Day 2 - Back & Biceps (planIds[1])
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[1],
        name: 'Pull-ups / Inverted Rows',
        sets: 4,
        repRange: '6-10',
        defaultRestSec: 90,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[1],
        name: 'Dumbbell Rows',
        sets: 4,
        repRange: '8-12',
        defaultRestSec: 60,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[1],
        name: 'Bicep Curls',
        sets: 3,
        repRange: '10-15',
        defaultRestSec: 45,
      ),

      // Day 3 - Legs (planIds[2])
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[2],
        name: 'Squats',
        sets: 4,
        repRange: '8-12',
        defaultRestSec: 90,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[2],
        name: 'Lunges',
        sets: 3,
        repRange: '10-12',
        defaultRestSec: 60,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[2],
        name: 'Calf Raises',
        sets: 4,
        repRange: '15-20',
        defaultRestSec: 45,
      ),

      // Day 4 - Shoulders (planIds[3])
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[3],
        name: 'Shoulder Press',
        sets: 4,
        repRange: '8-12',
        defaultRestSec: 60,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[3],
        name: 'Lateral Raises',
        sets: 3,
        repRange: '12-15',
        defaultRestSec: 45,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[3],
        name: 'Face Pulls',
        sets: 3,
        repRange: '12-15',
        defaultRestSec: 45,
      ),

      // Day 5 - Full Body (planIds[4])
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[4],
        name: 'Burpees',
        sets: 3,
        repRange: '10-15',
        defaultRestSec: 60,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[4],
        name: 'Mountain Climbers',
        sets: 3,
        repRange: '20-30',
        defaultRestSec: 45,
      ),
      WorkoutExercisesCompanion.insert(
        id: uuid.v4(),
        planId: planIds[4],
        name: 'Plank',
        sets: 3,
        repRange: '30-60 sec',
        defaultRestSec: 30,
      ),
    ];
  }
}
