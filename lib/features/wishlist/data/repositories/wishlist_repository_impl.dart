part of 'repositories.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  @override
  Future<void> addToWishlist({
    required int productId,
    required String userId,
  }) async {
    final wishlistItem = WishlistItemModel.create(
      productId: productId,
      userId: userId,
    );
    await HiveService.addToWishlist(wishlistItem);
  }

  @override
  Future<void> removeFromWishlist({
    required int productId,
    required String userId,
  }) async {
    await HiveService.removeFromWishlist(
      userId: userId,
      productId: productId,
    );
  }

  @override
  Future<List<WishlistItemEntity>> getUserWishlist(String userId) async {
    final wishlistItems = HiveService.getUserWishlist(userId);
    return wishlistItems.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> isInWishlist({
    required int productId,
    required String userId,
  }) async {
    return HiveService.isInWishlist(
      userId: userId,
      productId: productId,
    );
  }

  @override
  Future<void> clearUserWishlist(String userId) async {
    await HiveService.clearUserWishlist(userId);
  }

  @override
  Future<bool> toggleWishlist({
    required int productId,
    required String userId,
  }) async {
    final isCurrentlyInWishlist = await isInWishlist(
      productId: productId,
      userId: userId,
    );

    if (isCurrentlyInWishlist) {
      await removeFromWishlist(productId: productId, userId: userId);
      return false; // Removed from wishlist
    } else {
      await addToWishlist(productId: productId, userId: userId);
      return true; // Added to wishlist
    }
  }
}
