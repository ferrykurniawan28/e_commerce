import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  const RemoveFromWishlistUseCase({required this.repository});

  Future<void> call({
    required int productId,
    required String userId,
  }) async {
    return await repository.removeFromWishlist(
      productId: productId,
      userId: userId,
    );
  }
}
