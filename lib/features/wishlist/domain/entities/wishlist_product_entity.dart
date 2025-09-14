import 'package:equatable/equatable.dart';
import 'package:e_commerce/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';

class WishlistProductEntity extends Equatable {
  final WishlistItemEntity wishlistItem;
  final ProductEntity product;

  const WishlistProductEntity({
    required this.wishlistItem,
    required this.product,
  });

  @override
  List<Object?> get props => [wishlistItem, product];

  @override
  String toString() {
    return 'WishlistProductEntity(wishlistItem: $wishlistItem, product: $product)';
  }
}
