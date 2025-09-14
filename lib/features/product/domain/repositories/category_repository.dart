part of 'repositories.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<CategoryEntity>> getCategoriesWithProducts();
}
