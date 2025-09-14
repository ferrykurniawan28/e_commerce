import '../repositories/repositories.dart';
import '../entities/entities.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase({required this.repository});

  Future<List<CartItemEntity>> call(String userId) async {
    return await repository.getCartItems(userId);
  }
}
