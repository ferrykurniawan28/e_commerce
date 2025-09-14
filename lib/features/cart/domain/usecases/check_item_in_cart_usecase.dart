import '../repositories/repositories.dart';

class CheckItemInCartUseCase {
  final CartRepository repository;

  CheckItemInCartUseCase({required this.repository});

  Future<bool> call({
    required String userId,
    required int productId,
  }) async {
    return await repository.isInCart(
      userId: userId,
      productId: productId,
    );
  }
}
