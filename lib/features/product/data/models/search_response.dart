part of 'models.dart';

class SearchResponseModel extends Equatable {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const SearchResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      products: (json['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  @override
  List<Object> get props => [products, total, skip, limit];
}
