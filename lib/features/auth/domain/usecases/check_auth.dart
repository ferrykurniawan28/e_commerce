part of 'usecases.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  UserEntity? call() {
    return repository.currentUser;
  }
}
