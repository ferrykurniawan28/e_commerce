import 'package:equatable/equatable.dart';

class WishlistItemEntity extends Equatable {
  final String id; // Unique identifier for the wishlist item
  final int productId;
  final String userId; // User's UID from Firebase
  final DateTime addedAt;

  const WishlistItemEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, productId, userId, addedAt];

  @override
  String toString() {
    return 'WishlistItemEntity(id: $id, productId: $productId, userId: $userId, addedAt: $addedAt)';
  }
}
