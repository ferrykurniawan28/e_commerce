part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlistEvent extends WishlistEvent {
  final String userId;

  const LoadWishlistEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddToWishlistEvent extends WishlistEvent {
  final int productId;
  final String userId;

  const AddToWishlistEvent({
    required this.productId,
    required this.userId,
  });

  @override
  List<Object> get props => [productId, userId];
}

class RemoveFromWishlistEvent extends WishlistEvent {
  final int productId;
  final String userId;

  const RemoveFromWishlistEvent({
    required this.productId,
    required this.userId,
  });

  @override
  List<Object> get props => [productId, userId];
}

class ToggleWishlistEvent extends WishlistEvent {
  final int productId;
  final String userId;

  const ToggleWishlistEvent({
    required this.productId,
    required this.userId,
  });

  @override
  List<Object> get props => [productId, userId];
}

class ClearWishlistEvent extends WishlistEvent {
  final String userId;

  const ClearWishlistEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CheckWishlistStatusEvent extends WishlistEvent {
  final int productId;
  final String userId;

  const CheckWishlistStatusEvent({
    required this.productId,
    required this.userId,
  });

  @override
  List<Object> get props => [productId, userId];
}

class ResetWishlistEvent extends WishlistEvent {
  const ResetWishlistEvent();

  @override
  List<Object> get props => [];
}
