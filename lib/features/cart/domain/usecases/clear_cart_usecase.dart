import '../repositories/repositories.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase({required this.repository});

  Future<void> call(String userId) async {
    await repository.clearCart(userId);
  }
}
