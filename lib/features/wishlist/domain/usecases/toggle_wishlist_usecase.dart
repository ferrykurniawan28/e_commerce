import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';

class ToggleWishlistUseCase {
  final WishlistRepository repository;

  const ToggleWishlistUseCase({required this.repository});

  /// Toggle wishlist status for a product
  /// Returns true if added to wishlist, false if removed
  Future<bool> call({
    required int productId,
    required String userId,
  }) async {
    return await repository.toggleWishlist(
      productId: productId,
      userId: userId,
    );
  }
}
