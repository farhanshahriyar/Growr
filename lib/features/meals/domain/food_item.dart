class FoodItem {
  final String id;
  final String name;
  final List<String> aliases;
  final String category;
  final String portionLabel;
  final int calories;
  final int proteinG;
  final int? carbsG;
  final int? fatsG;
  final bool affordable;
  final bool localPriority;

  const FoodItem({
    required this.id,
    required this.name,
    this.aliases = const [],
    required this.category,
    required this.portionLabel,
    required this.calories,
    required this.proteinG,
    this.carbsG,
    this.fatsG,
    required this.affordable,
    required this.localPriority,
  });
}
