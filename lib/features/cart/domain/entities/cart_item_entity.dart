import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String userId;
  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  final double discountPercentage;
  final int quantity;
  final DateTime addedAt;
  final DateTime updatedAt;

  const CartItemEntity({
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

  double get totalPrice {
    final discountedPrice = price - (price * discountPercentage / 100);
    return discountedPrice * quantity;
  }

  double get discountedPrice => price - (price * discountPercentage / 100);

  double get totalDiscount => (price - discountedPrice) * quantity;

  CartItemEntity copyWith({
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
    return CartItemEntity(
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

  @override
  List<Object> get props => [
        userId,
        productId,
        title,
        thumbnail,
        price,
        discountPercentage,
        quantity,
        addedAt,
        updatedAt,
      ];
}
