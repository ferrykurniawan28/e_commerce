part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final int totalItems;
  final int itemCount;
  final double totalPrice;

  const CartLoaded({
    required this.items,
    required this.totalItems,
    required this.itemCount,
    required this.totalPrice,
  });

  @override
  List<Object> get props => [items, totalItems, itemCount, totalPrice];

  CartLoaded copyWith({
    List<CartItemEntity>? items,
    int? totalItems,
    int? itemCount,
    double? totalPrice,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      itemCount: itemCount ?? this.itemCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

final class CartItemAdded extends CartState {
  final String message;

  const CartItemAdded({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartItemRemoved extends CartState {
  final String message;

  const CartItemRemoved({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartItemUpdated extends CartState {
  final String message;

  const CartItemUpdated({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartCleared extends CartState {
  final String message;

  const CartCleared({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartItemCount extends CartState {
  final int count;

  const CartItemCount({required this.count});

  @override
  List<Object> get props => [count];
}

final class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
