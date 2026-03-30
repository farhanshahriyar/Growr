import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/meals_controller.dart';
import '../../domain/food_item.dart';
import '../../domain/meal_log_entry.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../app/theme/app_colors.dart';

class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({super.key});

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen> {
  final Map<String, List<MealLogEntry>> _mealsByType = {
    'breakfast': [],
    'lunch': [],
    'snack': [],
    'dinner': [],
  };

  @override
  void initState() {
    super.initState();
    // Initialize with current data
    final logs = ref.read(todayMealsProvider);
    if (logs != null) {
      _groupMealsByType(logs);
    }
  }

  void _groupMealsByType(List<MealLogEntry> logs) {
    _mealsByType.updateAll((key, value) => []);
    for (final log in logs) {
      _mealsByType[log.mealType]?.add(log);
    }
    // Sort by loggedAt within each type
    for (final list in _mealsByType.values) {
      list.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    }
  }

  Future<void> _showAddFoodModal() async {
    final controller = MealsController(ref.read(mealsRepositoryProvider));
    final quickAddFoods = await controller.getQuickAddFoods();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddFoodBottomSheet(
        quickAddFoods: quickAddFoods,
        onFoodSelected: (food, mealType, quantity) async {
          await controller.logFood(food, mealType, quantity);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalsAsync = ref.watch(todayMealsTotalsProvider);
    final logsAsync = ref.watch(todayMealsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Meals'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: logsAsync.when(
        data: (logs) {
          _groupMealsByType(logs);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Totals header
                totalsAsync.maybeWhen(
                  data: (totals) {
                    return Row(
                      children: [
                        Expanded(
                          child: _MacroCard(
                            label: 'Calories',
                            value: totals.totalCalories.toString(),
                            goal: '2,800',
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MacroCard(
                            label: 'Protein',
                            value: '${totals.totalProtein}g',
                            goal: '140g',
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),

                // Quick Add section
                const Text(
                  'Quick Add',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inverseSurface,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: _QuickAddSection(
                    onFoodSelected: (food, quantity) async {
                      final controller = MealsController(ref.read(mealsRepositoryProvider));
                      await controller.logFood(food, 'snack', quantity); // Default to snack
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Meal type sections
                ..._MealTypeSection.mealTypes.map((type) {
                  final meals = _mealsByType[type] ?? [];
                  return _MealTypeSection(
                    mealType: type,
                    meals: meals,
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFoodModal,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.onPrimary),
        label: const Text('Add Food', style: TextStyle(color: AppColors.onPrimary)),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final String goal;
  final Color color;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'goal: $goal',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.inverseSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddSection extends ConsumerWidget {
  final Function(FoodItem, double) onFoodSelected;

  const _QuickAddSection({required this.onFoodSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickAddAsync = ref.watch(quickAddFoodsProvider);

    return quickAddAsync.when(
      data: (foods) {
        if (foods.isEmpty) {
          return const Center(
            child: Text('No quick-add foods available'),
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return _QuickAddChip(
              food: food,
              onTap: () => onFoodSelected(food, 1.0),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const _QuickAddChip({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                food.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.inverseSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${food.calories} kcal • ${food.proteinG}g',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.inverseSurface.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealTypeSection extends StatelessWidget {
  final String mealType;
  final List<MealLogEntry> meals;

  static const List<String> mealTypes = ['breakfast', 'lunch', 'snack', 'dinner'];

  const _MealTypeSection({
    required this.mealType,
    required this.meals,
  });

  String get _displayName {
    switch (mealType) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'snack':
        return 'Snacks';
      case 'dinner':
        return 'Dinner';
      default:
        return mealType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _displayName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.inverseSurface,
          ),
        ),
        const SizedBox(height: 8),
        if (meals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No ${_displayName.toLowerCase()} logged yet',
              style: TextStyle(
                color: AppColors.inverseSurface.withOpacity(0.5),
              ),
            ),
          )
        else
          ...meals.map((meal) => _MealEntryCard(
                entry: meal,
              )),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _MealEntryCard extends StatelessWidget {
  final MealLogEntry entry;

  const _MealEntryCard({
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final time = '${entry.loggedAt.hour}:${entry.loggedAt.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.note ?? 'Unknown food', // Food name stored in note field
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.inverseSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$time • ${entry.quantity}x portion • ${entry.calories} kcal • ${entry.proteinG}g protein',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
          // TODO: Add delete/edit actions later
        ],
      ),
    );
  }
}

class _AddFoodBottomSheet extends ConsumerStatefulWidget {
  final List<FoodItem> quickAddFoods;
  final Function(FoodItem, String, double) onFoodSelected;

  const _AddFoodBottomSheet({
    required this.quickAddFoods,
    required this.onFoodSelected,
  });

  @override
  ConsumerState<_AddFoodBottomSheet> createState() => _AddFoodBottomSheetState();
}

class _AddFoodBottomSheetState extends ConsumerState<_AddFoodBottomSheet> {
  final _searchController = TextEditingController();
  String _selectedMealType = 'snack';
  final List<String> _mealTypes = ['breakfast', 'lunch', 'snack', 'dinner'];
  List<FoodItem> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchResults = widget.quickAddFoods;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = widget.quickAddFoods;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final controller = MealsController(ref.read(mealsRepositoryProvider));
    final results = await controller.searchFoods(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.inverseSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Food',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inverseSurface,
                  ),
                ),
                _MealTypeDropdown(
                  value: _selectedMealType,
                  onChanged: (value) {
                    setState(() {
                      _selectedMealType = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search foods...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No foods found',
                        message: 'Try different keywords',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final food = _searchResults[index];
                          return _FoodResultTile(
                            food: food,
                            onTap: () {
                              widget.onFoodSelected(food, _selectedMealType, 1.0);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _MealTypeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _MealTypeDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.inverseSurface),
          items: const [
            DropdownMenuItem(value: 'breakfast', child: Text('Breakfast')),
            DropdownMenuItem(value: 'lunch', child: Text('Lunch')),
            DropdownMenuItem(value: 'snack', child: Text('Snack')),
            DropdownMenuItem(value: 'dinner', child: Text('Dinner')),
          ],
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.inverseSurface,
              ),
        ),
      ),
    );
  }
}

class _FoodResultTile extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const _FoodResultTile({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.inverseSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food.portionLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.inverseSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${food.calories} kcal',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                ),
                Text(
                  '${food.proteinG}g protein',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.inverseSurface.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
