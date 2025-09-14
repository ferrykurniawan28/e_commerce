import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';

class IsInWishlistUseCase {
  final WishlistRepository repository;

  const IsInWishlistUseCase({required this.repository});

  Future<bool> call({
    required int productId,
    required String userId,
  }) async {
    return await repository.isInWishlist(
      productId: productId,
      userId: userId,
    );
  }
}
