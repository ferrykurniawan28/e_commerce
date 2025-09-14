import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';

abstract class WishlistRepository {
  /// Add a product to the user's wishlist
  Future<void> addToWishlist({
    required int productId,
    required String userId,
  });

  /// Remove a product from the user's wishlist
  Future<void> removeFromWishlist({
    required int productId,
    required String userId,
  });

  /// Get all wishlist items for a user
  Future<List<WishlistItemEntity>> getUserWishlist(String userId);

  /// Check if a product is in the user's wishlist
  Future<bool> isInWishlist({
    required int productId,
    required String userId,
  });

  /// Clear all wishlist items for a user (when user logs out)
  Future<void> clearUserWishlist(String userId);

  /// Toggle wishlist status (add if not present, remove if present)
  Future<bool> toggleWishlist({
    required int productId,
    required String userId,
  });
}
