part of 'usecases.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
