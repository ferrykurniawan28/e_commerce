import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';
import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';
import 'package:e_commerce/features/product/domain/repositories/repositories.dart';

class GetWishlistWithProductsUseCase {
  final WishlistRepository wishlistRepository;
  final ProductRepository productRepository;

  const GetWishlistWithProductsUseCase({
    required this.wishlistRepository,
    required this.productRepository,
  });

  Future<List<WishlistProductEntity>> call(String userId) async {
    final wishlistItems = await wishlistRepository.getUserWishlist(userId);
    final results = <WishlistProductEntity>[];

    for (final item in wishlistItems) {
      try {
        final product = await productRepository.getProductById(item.productId);
        results.add(WishlistProductEntity(
          wishlistItem: item,
          product: product,
        ));
      } catch (e) {
        // Handle case where product might not be found
        // Log error but continue processing other items
        print('Error fetching product ${item.productId} for wishlist: $e');
        // Could add a placeholder product or skip this item
        // For now, we'll skip items where product can't be found
      }
    }

    return results;
  }
}
