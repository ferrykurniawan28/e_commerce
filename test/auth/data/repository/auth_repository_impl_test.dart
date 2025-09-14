import 'dart:async';

import 'package:e_commerce/core/errors/errors.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:e_commerce/features/auth/data/repositories/auth_reporistory_impl.dart';
import '../datasources/mock/mock_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockUser mockUser;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockUser = MockUser();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('loginWithEmailAndPassword', () {
    const tEmail = 'test@test.com';
    const tPassword = 'test123';
    final tUserEntity = UserEntity(id: '123', email: tEmail);

    setUp(() {
      // Mock the properties that the extension method uses
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(tEmail);
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.photoURL).thenReturn(null);
    });

    test(
      'should return UserEntity when remote data source is successful',
      () async {
        // Arrange
        when(
          () =>
              mockRemoteDataSource.loginWithEmailAndPassword(tEmail, tPassword),
        ).thenAnswer((_) async => mockUser);

        // Act
        final result = await repository.loginWithEmailAndPassword(
          tEmail,
          tPassword,
        );

        // Assert
        expect(result, equals(tUserEntity));
        verify(
          () =>
              mockRemoteDataSource.loginWithEmailAndPassword(tEmail, tPassword),
        ).called(1);
      },
    );

    test('should rethrow exceptions from remote data source', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.loginWithEmailAndPassword(tEmail, tPassword),
      ).thenThrow(InvalidCredentialsException(message: 'Wrong password'));

      // Act & Assert
      expect(
        () => repository.loginWithEmailAndPassword(tEmail, tPassword),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });

  group('registerWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUserEntity = UserEntity(id: '123', email: tEmail);

    setUp(() {
      // Mock the properties that the extension method uses
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(tEmail);
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.photoURL).thenReturn(null);
    });

    test('should return UserEntity when registration is successful', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.registerWithEmailAndPassword(
          tEmail,
          tPassword,
        ),
      ).thenAnswer((_) async => mockUser);

      // Act
      final result = await repository.registerWithEmailAndPassword(
        tEmail,
        tPassword,
      );

      // Assert
      expect(result, equals(tUserEntity));
      verify(
        () => mockRemoteDataSource.registerWithEmailAndPassword(
          tEmail,
          tPassword,
        ),
      ).called(1);
    });
  });

  group('user stream', () {
    test('should map Firebase User to UserEntity in stream', () async {
      // Arrange
      final tUserEntity = UserEntity(id: '123', email: 'test@example.com');

      // Mock the properties for the user stream test
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.photoURL).thenReturn(null);

      final streamController = StreamController<User?>();
      when(
        () => mockRemoteDataSource.user,
      ).thenAnswer((_) => streamController.stream);

      // Act
      final resultStream = repository.user;
      final results = <UserEntity?>[];
      final subscription = resultStream.listen(results.add);

      // Emit values
      streamController.add(mockUser);
      streamController.add(null);

      // Wait for events to be processed
      await Future.delayed(Duration.zero);

      await streamController.close();
      await subscription.cancel();

      // Assert
      expect(results, equals([tUserEntity, null]));
    });
  });

  group('logout', () {
    test('should call logout on remote data source', () async {
      // Arrange
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => {});

      // Act
      await repository.logout();

      // Assert
      verify(() => mockRemoteDataSource.logout()).called(1);
    });
  });

  group('forgotPassword', () {
    const tEmail = 'test@example.com';

    test('should call sendPasswordResetEmail on remote data source', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.sendPasswordResetEmail(tEmail),
      ).thenAnswer((_) async => {});

      // Act
      await repository.forgotPassword(tEmail);

      // Assert
      verify(
        () => mockRemoteDataSource.sendPasswordResetEmail(tEmail),
      ).called(1);
    });
  });

  group('currentUser', () {
    test('should return UserEntity when current user exists', () {
      // Arrange
      final tUserEntity = UserEntity(id: '123', email: 'test@example.com');
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn(null);
      when(() => mockUser.photoURL).thenReturn(null);
      when(() => mockRemoteDataSource.currentUser).thenReturn(mockUser);

      // Act
      final result = repository.currentUser;

      // Assert
      expect(result, equals(tUserEntity));
    });

    test('should return null when no current user', () {
      // Arrange
      when(() => mockRemoteDataSource.currentUser).thenReturn(null);

      // Act
      final result = repository.currentUser;

      // Assert
      expect(result, isNull);
    });
  });
}
