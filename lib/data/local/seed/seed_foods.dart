import 'package:uuid/uuid.dart';
import '../db/app_database.dart';
import 'package:drift/drift.dart';

class SeedFoods {
  static List<FoodsCompanion> getDefaultFoods() {
    const uuid = Uuid();
    
    return [
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Egg',
        category: 'Protein',
        portionLabel: '1 large',
        calories: 78,
        proteinG: 6,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Rice (Sada Bhat)',
        category: 'Carbs',
        portionLabel: '1 cup',
        calories: 205,
        proteinG: 4,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Masoor Dal',
        category: 'Legumes',
        portionLabel: '1 cup',
        calories: 230,
        proteinG: 16,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Roti',
        category: 'Carbs',
        portionLabel: '1 medium',
        calories: 120,
        proteinG: 3,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Chicken Breast (Local)',
        category: 'Protein',
        portionLabel: '100g',
        calories: 165,
        proteinG: 31,
        affordable: false,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Soy Chunks',
        category: 'Protein',
        portionLabel: '50g (dry)',
        calories: 170,
        proteinG: 26,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Chola (Chickpeas)',
        category: 'Legumes',
        portionLabel: '1 serving',
        calories: 269,
        proteinG: 14,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Milk',
        category: 'Dairy',
        portionLabel: '1 glass (250ml)',
        calories: 150,
        proteinG: 8,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Banana',
        category: 'Fruit',
        portionLabel: '1 medium',
        calories: 105,
        proteinG: 1,
        affordable: true,
        localPriority: true,
      ),
      FoodsCompanion.insert(
        id: uuid.v4(),
        name: 'Fish (Rui/Katla)',
        category: 'Protein',
        portionLabel: '1 piece (100g)',
        calories: 100,
        proteinG: 18,
        affordable: true,
        localPriority: true,
      ),
    ];
  }
}
