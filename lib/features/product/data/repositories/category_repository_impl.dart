part of 'repositories.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<CategoryEntity>> getCategories() async {
    if (await networkInfo.isConnected) {
      final categories = await remoteDataSource.getCategories();
      return categories.map((model) => model.toEntity()).toList();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategoriesWithProducts() async {
    // This could be implemented to fetch categories with sample products
    // For now, we'll just return regular categories
    return getCategories();
  }
}
