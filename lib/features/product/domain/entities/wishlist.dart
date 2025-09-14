part of 'entities.dart';

class WishlistEntity {
  final int productId;
  final String userId;
  final DateTime timestamp;

  const WishlistEntity({
    required this.productId,
    required this.userId,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistEntity &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          userId == other.userId;

  @override
  int get hashCode => productId.hashCode ^ userId.hashCode;
}
