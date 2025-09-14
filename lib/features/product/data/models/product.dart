part of 'models.dart';

class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double? rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String? sku;
  final int? weight;
  final DimensionsModel? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<ReviewModel>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final MetaModel? meta;
  final String thumbnail;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'],
      sku: json['sku'],
      weight: json['weight'],
      dimensions: json['dimensions'] != null
          ? DimensionsModel.fromJson(json['dimensions'])
          : null,
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      availabilityStatus: json['availabilityStatus'],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
                .map((review) => ReviewModel.fromJson(review))
                .toList()
          : null,
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      meta: json['meta'] != null ? MetaModel.fromJson(json['meta']) : null,
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions?.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews?.map((review) => review.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta?.toJson(),
      'thumbnail': thumbnail,
      'images': images,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      tags: tags,
      brand: brand,
      sku: sku,
      weight: weight,
      dimensions: dimensions?.toEntity(),
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      availabilityStatus: availabilityStatus,
      reviews: reviews?.map((review) => review.toEntity()).toList(),
      returnPolicy: returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity,
      meta: meta?.toEntity(),
      thumbnail: thumbnail,
      images: images,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    tags,
    brand,
    sku,
    weight,
    dimensions,
    warrantyInformation,
    shippingInformation,
    availabilityStatus,
    reviews,
    returnPolicy,
    minimumOrderQuantity,
    meta,
    thumbnail,
    images,
  ];
}
