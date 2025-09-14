import '../entities/entities.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems(String userId);
  Future<void> addToCart({
    required String userId,
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    int quantity = 1,
  });
  Future<void> removeFromCart({
    required String userId,
    required int productId,
  });
  Future<void> updateCartItemQuantity({
    required String userId,
    required int productId,
    required int quantity,
  });
  Future<void> clearCart(String userId);
  Future<bool> isInCart({
    required String userId,
    required int productId,
  });
  Future<int> getTotalItemCount(String userId);
  Future<int> getCartItemCount(String userId);
}
