import '../repositories/repositories.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase({required this.repository});

  Future<void> call({
    required String userId,
    required int productId,
  }) async {
    await repository.removeFromCart(
      userId: userId,
      productId: productId,
    );
  }
}
