part of 'usecases.dart';

class GetCategoriesWithProductsUseCase {
  final CategoryRepository repository;

  GetCategoriesWithProductsUseCase({required this.repository});

  Future<List<CategoryEntity>> call() {
    return repository.getCategoriesWithProducts();
  }
}
