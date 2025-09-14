class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        displayName.hashCode ^
        photoUrl.hashCode;
  }
}
