import 'package:flutter/material.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';

class CategoryFilter extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedCategory;
  final Function(CategoryEntity) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Create a list with "All" as the first option
    final allCategories = [
      CategoryEntity(name: 'All', slug: 'all', url: ''),
      ...categories,
    ];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected = selectedCategory == category.name;

          return Padding(
            padding: EdgeInsets.only(
              right: index == allCategories.length - 1 ? 0 : 8.0,
            ),
            child: FilterChip(
              label: Text(
                category.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                onCategorySelected(category);
              },
              backgroundColor: isDark
                  ? theme.colorScheme.surfaceContainerHighest
                  : Colors.grey.shade200,
              selectedColor: theme.colorScheme.primary,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : isDark
                          ? theme.colorScheme.outline.withOpacity(0.3)
                          : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: isDark ? 2 : 0,
              shadowColor:
                  isDark ? Colors.black.withOpacity(0.3) : Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}
