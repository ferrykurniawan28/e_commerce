part of 'wishlist_bloc.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<WishlistProductEntity> wishlistProducts;
  final Map<int, bool> wishlistStatus; // productId -> isInWishlist

  const WishlistLoaded({
    required this.wishlistProducts,
    required this.wishlistStatus,
  });

  @override
  List<Object> get props => [wishlistProducts, wishlistStatus];

  WishlistLoaded copyWith({
    List<WishlistProductEntity>? wishlistProducts,
    Map<int, bool>? wishlistStatus,
  }) {
    return WishlistLoaded(
      wishlistProducts: wishlistProducts ?? this.wishlistProducts,
      wishlistStatus: wishlistStatus ?? this.wishlistStatus,
    );
  }
}

final class WishlistError extends WishlistState {
  final String message;

  const WishlistError({required this.message});

  @override
  List<Object> get props => [message];
}

final class WishlistItemAdded extends WishlistState {
  final int productId;
  final List<WishlistProductEntity> wishlistProducts;
  final Map<int, bool> wishlistStatus;

  const WishlistItemAdded({
    required this.productId,
    required this.wishlistProducts,
    required this.wishlistStatus,
  });

  @override
  List<Object> get props => [productId, wishlistProducts, wishlistStatus];
}

final class WishlistItemRemoved extends WishlistState {
  final int productId;
  final List<WishlistProductEntity> wishlistProducts;
  final Map<int, bool> wishlistStatus;

  const WishlistItemRemoved({
    required this.productId,
    required this.wishlistProducts,
    required this.wishlistStatus,
  });

  @override
  List<Object> get props => [productId, wishlistProducts, wishlistStatus];
}

final class WishlistCleared extends WishlistState {
  final String userId;

  const WishlistCleared({required this.userId});

  @override
  List<Object> get props => [userId];
}
