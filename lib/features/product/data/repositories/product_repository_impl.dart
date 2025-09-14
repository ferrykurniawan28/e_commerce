part of 'repositories.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int skip,
    String? category,
  }) async {
    if (await networkInfo.isConnected) {
      final products = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
        category: category,
      );
      return products.map((model) => model.toEntity()).toList();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<ProductEntity> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      final product = await remoteDataSource.getProductById(id);
      return product.toEntity();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    if (await networkInfo.isConnected) {
      final products = await remoteDataSource.searchProducts(query);
      return products.map((model) => model.toEntity()).toList();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getCategories();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }
}
