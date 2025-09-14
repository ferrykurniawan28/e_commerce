part of 'usecases.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<void> call(String email) {
    return repository.forgotPassword(email);
  }
}
