import '../repositories/repositories.dart';

class UpdateCartItemQuantityUseCase {
  final CartRepository repository;

  UpdateCartItemQuantityUseCase({required this.repository});

  Future<void> call({
    required String userId,
    required int productId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      await repository.removeFromCart(
        userId: userId,
        productId: productId,
      );
    } else {
      await repository.updateCartItemQuantity(
        userId: userId,
        productId: productId,
        quantity: quantity,
      );
    }
  }
}
