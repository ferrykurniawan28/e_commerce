part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {
  final String userId;

  const LoadCartEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddToCartEvent extends CartEvent {
  final String userId;
  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  final double discountPercentage;
  final int quantity;

  const AddToCartEvent({
    required this.userId,
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [
        userId,
        productId,
        title,
        thumbnail,
        price,
        discountPercentage,
        quantity,
      ];
}

class RemoveFromCartEvent extends CartEvent {
  final String userId;
  final int productId;

  const RemoveFromCartEvent({
    required this.userId,
    required this.productId,
  });

  @override
  List<Object> get props => [userId, productId];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final String userId;
  final int productId;
  final int quantity;

  const UpdateCartItemQuantityEvent({
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [userId, productId, quantity];
}

class ClearCartEvent extends CartEvent {
  final String userId;

  const ClearCartEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetCartItemCountEvent extends CartEvent {
  final String userId;

  const GetCartItemCountEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ResetCartEvent extends CartEvent {
  const ResetCartEvent();
}
