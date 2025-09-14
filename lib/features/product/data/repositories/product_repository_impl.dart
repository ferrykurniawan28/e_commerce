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

        // Cache products appropriately
        if (skip == 0 && category == null) {
          // First page - replace all cached products
          await HiveService.cacheProducts(products);
        } else if (category == null) {
          // Pagination - add to existing cache
          await HiveService.cacheAdditionalProducts(products);
        } else {}
        // Don't cache category-filtered products to avoid confusion

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
      // No network - try to serve from cache with proper pagination
      if (HiveService.hasProducts) {
        final cachedProducts = HiveService.getCachedProducts();

        // Filter by category if needed
        List<ProductModel> filteredProducts = cachedProducts;
        if (category != null) {
          filteredProducts = cachedProducts
              .where((product) =>
                  product.category.toLowerCase() == category.toLowerCase())
              .toList();
        }

        // Apply pagination to cached data
        final totalCached = filteredProducts.length;

        // If skip is beyond available data, return empty list
        if (skip >= totalCached) {
          return [];
        }

        // Calculate the slice of data to return
        final endIndex = (skip + limit).clamp(0, totalCached);
        final paginatedProducts = filteredProducts.sublist(skip, endIndex);

        return paginatedProducts.map((model) => model.toEntity()).toList();
      }

      throw NetworkException(
          message: 'No internet connection and no cached data available');
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
        // Cache the product (will update if exists)
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
