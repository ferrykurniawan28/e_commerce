import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:e_commerce/core/errors/errors.dart';
import 'package:e_commerce/features/auth/data/datasources/auth_datasource_impl.dart';
import 'mock/mock_firebase.dart';

void main() {
  late AuthRemoteDataSource dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    dataSource = AuthRemoteDataSource(firebaseAuth: mockFirebaseAuth);
  });

  group('loginWithEmailAndPassword', () {
    const tEmail = 'test@test.com';
    const tPassword = 'test123';
    const tUserId = 'rxyRE84s3efTeJXMLs0FseWxGhO2';

    setUp(() {
      when(() => mockUser.uid).thenReturn(tUserId);
      when(() => mockUser.email).thenReturn(tEmail);
      when(() => mockUserCredential.user).thenReturn(mockUser);
    });

    test('should return User when login is successful', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await dataSource.loginWithEmailAndPassword(
        tEmail,
        tPassword,
      );

      // Assert
      expect(result, equals(mockUser));
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });

    test(
      'should throw InvalidCredentialsException when wrong password',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        // Act & Assert
        expect(
          () => dataSource.loginWithEmailAndPassword(tEmail, tPassword),
          throwsA(isA<InvalidCredentialsException>()),
        );
      },
    );

    test('should throw NotFoundException when user not found', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      // Act & Assert
      expect(
        () => dataSource.loginWithEmailAndPassword(tEmail, tPassword),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('should throw ServerException on generic Firebase error', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(FirebaseAuthException(code: 'unknown-error'));

      // Act & Assert
      expect(
        () => dataSource.loginWithEmailAndPassword(tEmail, tPassword),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('registerWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should return User when registration is successful', () async {
      // Arrange
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await dataSource.registerWithEmailAndPassword(
        tEmail,
        tPassword,
      );

      // Assert
      expect(result, equals(mockUser));
      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
    });

    test('should throw EmailAlreadyInUseException when email exists', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act & Assert
      expect(
        () => dataSource.registerWithEmailAndPassword(tEmail, tPassword),
        throwsA(isA<EmailAlreadyInUseException>()),
      );
    });

    test('should throw WeakPasswordException when password is weak', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(FirebaseAuthException(code: 'weak-password'));

      // Act & Assert
      expect(
        () => dataSource.registerWithEmailAndPassword(tEmail, tPassword),
        throwsA(isA<WeakPasswordException>()),
      );
    });
  });

  group('logout', () {
    test('should call signOut on FirebaseAuth', () async {
      // Arrange
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      // Act
      await dataSource.logout();

      // Assert
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('should throw ServerException on logout failure', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.signOut(),
      ).thenThrow(FirebaseAuthException(code: 'logout-failed'));

      // Act & Assert
      expect(() => dataSource.logout(), throwsA(isA<ServerException>()));
    });
  });

  group('sendPasswordResetEmail', () {
    const tEmail = 'test@example.com';

    test('should call sendPasswordResetEmail on FirebaseAuth', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.sendPasswordResetEmail(tEmail);

      // Assert
      verify(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
      ).called(1);
    });

    test('should throw ServerException on reset email failure', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
      ).thenThrow(FirebaseAuthException(code: 'reset-failed'));

      // Act & Assert
      expect(
        () => dataSource.sendPasswordResetEmail(tEmail),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('user stream', () {
    test('should return user stream from FirebaseAuth', () {
      // Arrange
      final streamController = StreamController<User?>();
      when(
        () => mockFirebaseAuth.userChanges(),
      ).thenAnswer((_) => streamController.stream);

      // Act
      final result = dataSource.user;

      // Assert
      expect(result, equals(streamController.stream));
      verify(() => mockFirebaseAuth.userChanges()).called(1);
    });
  });
}
