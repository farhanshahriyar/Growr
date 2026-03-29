class MealLogEntry {
  final String id;
  final String mealType; // breakfast | lunch | snack | dinner
  final String foodItemId;
  final double quantity; // e.g., 1.5 portions
  final int calories;
  final int proteinG;
  final DateTime loggedAt;
  final String? note;

  const MealLogEntry({
    required this.id,
    required this.mealType,
    required this.foodItemId,
    required this.quantity,
    required this.calories,
    required this.proteinG,
    required this.loggedAt,
    this.note,
  });
}
