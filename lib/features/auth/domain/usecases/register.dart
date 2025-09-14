part of 'usecases.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) {
    return repository.registerWithEmailAndPassword(email, password);
  }
}
