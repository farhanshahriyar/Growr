import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/meals_controller.dart';
import '../domain/food_item.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/primary_button.dart';

class FoodSearchSheet extends ConsumerStatefulWidget {
  final String mealType;

  const FoodSearchSheet({super.key, required this.mealType});

  @override
  ConsumerState<FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends ConsumerState<FoodSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _results = [];
  bool _isSearching = false;

  void _onSearch(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => _results = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await ref.read(mealsControllerProvider).searchFoods(query);
    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  void _onFoodSelected(FoodItem food) {
    // For MVP, we'll log it directly as 1 portion, but in production we'd open a quantity picker
    ref.read(mealsControllerProvider).logFood(food, widget.mealType, 1.0);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.inverseSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
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
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Text('No affordable foods found.'))
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final food = _results[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            title: Text(food.name, style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Text('${food.portionLabel} • ${food.calories} kcal • ${food.proteinG}g protein',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.inverseSurface.withOpacity(0.6))),
                            onTap: () => _onFoodSelected(food),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
