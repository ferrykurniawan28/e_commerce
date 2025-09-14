import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';
import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';

class GetUserWishlistUseCase {
  final WishlistRepository repository;

  const GetUserWishlistUseCase({required this.repository});

  Future<List<WishlistItemEntity>> call(String userId) async {
    return await repository.getUserWishlist(userId);
  }
}
