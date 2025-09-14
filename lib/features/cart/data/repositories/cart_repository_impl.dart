import '../../domain/domain.dart';
import '../models/models.dart';
import '../../../../core/services/hive_service.dart';

class CartRepositoryImpl implements CartRepository {
  @override
  Future<List<CartItemEntity>> getCartItems(String userId) async {
    final cartItems = HiveService.getUserCart(userId);
    return cartItems.map((item) => item.toEntity()).toList();
  }

  @override
  Future<void> addToCart({
    required String userId,
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    int quantity = 1,
  }) async {
    // Check if item already exists
    final existingItem = HiveService.getCartItem(
      userId: userId,
      productId: productId,
    );

    final now = DateTime.now();

    if (existingItem != null) {
      // Update existing item quantity
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        updatedAt: now,
      );
      await HiveService.updateCartItem(updatedItem);
    } else {
      // Add new item
      final cartItem = CartItemModel(
        userId: userId,
        productId: productId,
        title: title,
        thumbnail: thumbnail,
        price: price,
        discountPercentage: discountPercentage,
        quantity: quantity,
        addedAt: now,
        updatedAt: now,
      );
      await HiveService.addToCart(cartItem);
    }
  }

  @override
  Future<void> removeFromCart({
    required String userId,
    required int productId,
  }) async {
    await HiveService.removeFromCart(
      userId: userId,
      productId: productId,
    );
  }

  @override
  Future<void> updateCartItemQuantity({
    required String userId,
    required int productId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      await removeFromCart(userId: userId, productId: productId);
      return;
    }

    final existingItem = HiveService.getCartItem(
      userId: userId,
      productId: productId,
    );

    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(
        quantity: quantity,
        updatedAt: DateTime.now(),
      );
      await HiveService.updateCartItem(updatedItem);
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    await HiveService.clearUserCart(userId);
  }

  @override
  Future<bool> isInCart({
    required String userId,
    required int productId,
  }) async {
    return HiveService.isInCart(
      userId: userId,
      productId: productId,
    );
  }

  @override
  Future<int> getTotalItemCount(String userId) async {
    return HiveService.getTotalCartQuantity(userId);
  }

  @override
  Future<int> getCartItemCount(String userId) async {
    return HiveService.getCartItemCount(userId);
  }
}
