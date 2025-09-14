part of 'entities.dart';

class ProductEntity {
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
  final DimensionsEntity? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<ReviewEntity>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final MetaEntity? meta;
  final String thumbnail;
  final List<String> images;

  ProductEntity({
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

  // Helper getter for discounted price
  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  // Helper getter to check if product is in stock
  bool get inStock => stock > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.price == price &&
        other.discountPercentage == discountPercentage &&
        other.rating == rating &&
        other.stock == stock &&
        other.tags == tags &&
        other.brand == brand &&
        other.sku == sku &&
        other.weight == weight &&
        other.dimensions == dimensions &&
        other.warrantyInformation == warrantyInformation &&
        other.shippingInformation == shippingInformation &&
        other.availabilityStatus == availabilityStatus &&
        other.reviews == reviews &&
        other.returnPolicy == returnPolicy &&
        other.minimumOrderQuantity == minimumOrderQuantity &&
        other.meta == meta &&
        other.thumbnail == thumbnail &&
        other.images == images;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      price.hashCode ^
      discountPercentage.hashCode ^
      (rating?.hashCode ?? 0) ^
      stock.hashCode ^
      tags.hashCode ^
      (brand?.hashCode ?? 0) ^
      (sku?.hashCode ?? 0) ^
      (weight?.hashCode ?? 0) ^
      (dimensions?.hashCode ?? 0) ^
      (warrantyInformation?.hashCode ?? 0) ^
      (shippingInformation?.hashCode ?? 0) ^
      (availabilityStatus?.hashCode ?? 0) ^
      (reviews?.hashCode ?? 0) ^
      (returnPolicy?.hashCode ?? 0) ^
      (minimumOrderQuantity?.hashCode ?? 0) ^
      (meta?.hashCode ?? 0) ^
      thumbnail.hashCode ^
      images.hashCode;
}
