import 'package:e_commerce/core/errors/errors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get user => _firebaseAuth.userChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error during login');
    }
  }

  Future<User> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error during registration');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error during logout');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error sending reset email');
    }
  }

  /// Helper method to map FirebaseAuthException to our custom exceptions
  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return NotFoundException(message: 'No user found for that email.');
      case 'wrong-password':
        return InvalidCredentialsException(message: 'Wrong password provided.');
      case 'email-already-in-use':
        return EmailAlreadyInUseException(message: 'Email already in use.');
      case 'invalid-email':
        return InvalidEmailException(message: 'Invalid email address.');
      case 'user-disabled':
        return UserDisabledException(
          message: 'User account has been disabled.',
        );
      case 'operation-not-allowed':
        return OperationNotAllowedException(message: 'Operation not allowed.');
      case 'weak-password':
        return WeakPasswordException(message: 'Password is too weak.');
      default:
        return ServerException(message: e.message ?? 'Authentication failed');
    }
  }
}
