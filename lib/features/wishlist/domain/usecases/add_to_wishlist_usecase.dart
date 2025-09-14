import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  const AddToWishlistUseCase({required this.repository});

  Future<void> call({
    required int productId,
    required String userId,
  }) async {
    return await repository.addToWishlist(
      productId: productId,
      userId: userId,
    );
  }
}
