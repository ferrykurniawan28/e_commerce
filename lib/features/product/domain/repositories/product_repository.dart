part of 'repositories.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int skip,
    String? category,
  });

  Future<ProductEntity> getProductById(int id);
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<String>> getCategories();
}
