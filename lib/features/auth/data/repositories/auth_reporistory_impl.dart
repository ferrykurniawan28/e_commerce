import 'package:e_commerce/core/errors/errors.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/core/utils/utils.dart';
import 'package:e_commerce/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Stream<UserEntity?> get user {
    return remoteDataSource.user.map((firebaseUser) {
      return firebaseUser?.toEntity();
    });
  }

  @override
  Future<UserEntity> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      final user = await remoteDataSource.loginWithEmailAndPassword(
        email,
        password,
      );
      return user.toEntity();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      final user = await remoteDataSource.registerWithEmailAndPassword(
        email,
        password,
      );
      return user.toEntity();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<void> logout() async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.logout();
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.sendPasswordResetEmail(email);
    } else {
      throw NetworkException(message: 'No internet connection');
    }
  }

  @override
  UserEntity? get currentUser {
    final user = remoteDataSource.currentUser;
    return user?.toEntity();
  }
}
