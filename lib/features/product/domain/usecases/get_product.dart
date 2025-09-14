part of 'usecases.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call({
    required int limit,
    required int skip,
    String? category,
  }) {
    return repository.getProducts(limit: limit, skip: skip, category: category);
  }
}
