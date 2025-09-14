import 'package:hive/hive.dart';
import '../../domain/entities/entities.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 5)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final int productId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String thumbnail;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double discountPercentage;

  @HiveField(6)
  final int quantity;

  @HiveField(7)
  final DateTime addedAt;

  @HiveField(8)
  final DateTime updatedAt;

  CartItemModel({
    required this.userId,
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    required this.quantity,
    required this.addedAt,
    required this.updatedAt,
  });

  CartItemEntity toEntity() {
    return CartItemEntity(
      userId: userId,
      productId: productId,
      title: title,
      thumbnail: thumbnail,
      price: price,
      discountPercentage: discountPercentage,
      quantity: quantity,
      addedAt: addedAt,
      updatedAt: updatedAt,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      userId: entity.userId,
      productId: entity.productId,
      title: entity.title,
      thumbnail: entity.thumbnail,
      price: entity.price,
      discountPercentage: entity.discountPercentage,
      quantity: entity.quantity,
      addedAt: entity.addedAt,
      updatedAt: entity.updatedAt,
    );
  }

  CartItemModel copyWith({
    String? userId,
    int? productId,
    String? title,
    String? thumbnail,
    double? price,
    double? discountPercentage,
    int? quantity,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return CartItemModel(
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
