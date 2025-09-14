part of 'utils.dart';

extension FirebaseUserX on User {
  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      email: email!,
      displayName: displayName,
      photoUrl: photoURL,
    );
  }
}
