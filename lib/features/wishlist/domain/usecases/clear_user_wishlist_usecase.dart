import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';

class ClearUserWishlistUseCase {
  final WishlistRepository repository;

  const ClearUserWishlistUseCase({required this.repository});

  Future<void> call(String userId) async {
    return await repository.clearUserWishlist(userId);
  }
}
