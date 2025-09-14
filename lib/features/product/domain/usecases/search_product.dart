part of 'usecases.dart';

class SearchProductsUseCase {
  final ProductRepository repository;

  SearchProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call(String query) {
    return repository.searchProducts(query);
  }
}
