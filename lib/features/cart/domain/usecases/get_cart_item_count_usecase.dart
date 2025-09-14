import '../repositories/repositories.dart';

class GetCartItemCountUseCase {
  final CartRepository repository;

  GetCartItemCountUseCase({required this.repository});

  Future<int> call(String userId) async {
    return await repository.getCartItemCount(userId);
  }
}
