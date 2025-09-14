import '../repositories/repositories.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase({required this.repository});

  Future<void> call({
    required String userId,
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    int quantity = 1,
  }) async {
    await repository.addToCart(
      userId: userId,
      productId: productId,
      title: title,
      thumbnail: thumbnail,
      price: price,
      discountPercentage: discountPercentage,
      quantity: quantity,
    );
  }
}
