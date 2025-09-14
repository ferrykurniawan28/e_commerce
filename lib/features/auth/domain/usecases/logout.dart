part of 'usecases.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() {
    return repository.logout();
  }
}
