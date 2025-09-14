part of 'datasources.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
    String? category,
  });

  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
    String? category,
  }) async {
    try {
      String url = baseUrl + productsEndpoint;
      if (category != null) {
        url = '$url/category/$category';
      }

      final response = await dio.get(
        url,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      print(response.data);

      final productsResponse = ProductsResponseModel.fromJson(response.data);
      print(productsResponse.products);
      return productsResponse.products;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch products',
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dio.get('$baseUrl/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Product not found');
      }
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch product',
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await dio.get(
        '$baseUrl/products/search',
        queryParameters: {'q': query},
      );

      final searchResponse = SearchResponseModel.fromJson(response.data);
      return searchResponse.products;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to search products',
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await dio.get('$baseUrl/products/categories');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch categories',
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}
