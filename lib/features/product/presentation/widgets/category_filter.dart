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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                onCategorySelected(category);
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
