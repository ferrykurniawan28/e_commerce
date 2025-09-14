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
      try {
        final products = await remoteDataSource.getProducts(
          limit: limit,
          skip: skip,
          category: category,
        );

        // Cache products if this is the first page and no category filter
        if (skip == 0 && category == null) {
          await HiveService.cacheProducts(products);
        }

        return products.map((model) => model.toEntity()).toList();
      } catch (e) {
        // If network fails, try to get from cache
        if (skip == 0 && category == null && HiveService.hasProducts) {
          final cachedProducts = HiveService.getCachedProducts();
          return cachedProducts.map((model) => model.toEntity()).toList();
        }
        rethrow;
      }
    } else {
      // No network, get from cache
      if (skip == 0 && category == null && HiveService.hasProducts) {
        final cachedProducts = HiveService.getCachedProducts();
        return cachedProducts.map((model) => model.toEntity()).toList();
      }
      throw NetworkException(
          message: 'No internet connection and no cached data');
    }
  }

  @override
  Future<ProductEntity> getProductById(int id) async {
    // First try to get from cache
    final cachedProduct = HiveService.getCachedProduct(id);
    if (cachedProduct != null) {
      return cachedProduct.toEntity();
    }

    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        // Cache the product
        await HiveService.cacheProduct(product);
        return product.toEntity();
      } catch (e) {
        rethrow;
      }
    } else {
      throw NetworkException(
          message: 'No internet connection and product not cached');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    if (await networkInfo.isConnected) {
      final products = await remoteDataSource.searchProducts(query);
      return products.map((model) => model.toEntity()).toList();
    } else {
      // For search, we could implement basic local search on cached products
      if (HiveService.hasProducts) {
        final cachedProducts = HiveService.getCachedProducts();
        final filteredProducts = cachedProducts
            .where((product) =>
                product.title.toLowerCase().contains(query.toLowerCase()) ||
                product.description
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return filteredProducts.map((model) => model.toEntity()).toList();
      }
      throw NetworkException(
          message: 'No internet connection and no cached data for search');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        // Cache categories
        await HiveService.cacheCategories(categories);
        return categories;
      } catch (e) {
        // If network fails, try to get from cache
        if (HiveService.hasCategories) {
          return HiveService.getCachedCategories();
        }
        rethrow;
      }
    } else {
      // No network, get from cache
      if (HiveService.hasCategories) {
        return HiveService.getCachedCategories();
      }
      throw NetworkException(
          message: 'No internet connection and no cached categories');
    }
  }
}
