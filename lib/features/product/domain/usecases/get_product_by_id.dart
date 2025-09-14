part of 'usecases.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase({required this.repository});

  Future<ProductEntity> call(int id) {
    return repository.getProductById(id);
  }
}
