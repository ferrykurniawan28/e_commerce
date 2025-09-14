part of 'usecases.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) {
    return repository.loginWithEmailAndPassword(email, password);
  }
}
