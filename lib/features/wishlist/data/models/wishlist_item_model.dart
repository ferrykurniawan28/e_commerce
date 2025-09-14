part of 'models.dart';

@HiveType(typeId: 4)
class WishlistItemModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int productId;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final DateTime addedAt;

  const WishlistItemModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.addedAt,
  });

  // Convert from entity
  factory WishlistItemModel.fromEntity(WishlistItemEntity entity) {
    return WishlistItemModel(
      id: entity.id,
      productId: entity.productId,
      userId: entity.userId,
      addedAt: entity.addedAt,
    );
  }

  // Convert to entity
  WishlistItemEntity toEntity() {
    return WishlistItemEntity(
      id: id,
      productId: productId,
      userId: userId,
      addedAt: addedAt,
    );
  }

  // Factory constructor for creating a new wishlist item
  factory WishlistItemModel.create({
    required int productId,
    required String userId,
  }) {
    final now = DateTime.now();
    final id = '${userId}_${productId}_${now.millisecondsSinceEpoch}';

    return WishlistItemModel(
      id: id,
      productId: productId,
      userId: userId,
      addedAt: now,
    );
  }

  @override
  List<Object?> get props => [id, productId, userId, addedAt];

  @override
  String toString() {
    return 'WishlistItemModel(id: $id, productId: $productId, userId: $userId, addedAt: $addedAt)';
  }
}
