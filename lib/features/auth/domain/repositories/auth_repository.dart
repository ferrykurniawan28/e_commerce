import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;
  Future<UserEntity> loginWithEmailAndPassword(String email, String password);
  Future<UserEntity> registerWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> logout();
  Future<void> forgotPassword(String email);
  UserEntity? get currentUser;
}
