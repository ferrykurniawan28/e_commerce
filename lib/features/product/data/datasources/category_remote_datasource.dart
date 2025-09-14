part of 'datasources.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio = Dio();

  CategoryRemoteDataSourceImpl();

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products/categories',
      );

      // The API returns a list of category objects, not just strings
      final categoriesData = response.data as List;

      return categoriesData.map((categoryData) {
        return CategoryModel.fromJson(categoryData);
      }).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch categories',
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
