part of 'errors.dart';

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException({required this.message});
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException({required this.message});
}

class EmailAlreadyInUseException implements Exception {
  final String message;
  EmailAlreadyInUseException({required this.message});
}

class InvalidEmailException implements Exception {
  final String message;
  InvalidEmailException({required this.message});
}

class UserDisabledException implements Exception {
  final String message;
  UserDisabledException({required this.message});
}

class OperationNotAllowedException implements Exception {
  final String message;
  OperationNotAllowedException({required this.message});
}

class WeakPasswordException implements Exception {
  final String message;
  WeakPasswordException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}
