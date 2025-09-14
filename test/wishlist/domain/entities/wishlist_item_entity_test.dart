import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';

void main() {
  group('WishlistItemEntity', () {
    const testId = 'user123_1_1699000000000';
    const testProductId = 1;
    const testUserId = 'user123';
    final testAddedAt = DateTime.fromMillisecondsSinceEpoch(1699000000000);

    group('Constructor', () {
      test('should create WishlistItemEntity with required parameters', () {
        // Act
        final entity = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(entity.id, testId);
        expect(entity.productId, testProductId);
        expect(entity.userId, testUserId);
        expect(entity.addedAt, testAddedAt);
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        final entity1 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final entity2 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(entity1, equals(entity2));
        expect(entity1.hashCode, equals(entity2.hashCode));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        final entity1 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final entity2 = WishlistItemEntity(
          id: 'different-id',
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('should not be equal when productId differs', () {
        // Arrange
        final entity1 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final entity2 = WishlistItemEntity(
          id: testId,
          productId: 999,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('should not be equal when userId differs', () {
        // Arrange
        final entity1 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final entity2 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: 'different-user',
          addedAt: testAddedAt,
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('should not be equal when addedAt differs', () {
        // Arrange
        final entity1 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final entity2 = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: DateTime.now(),
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });
    });

    group('toString', () {
      test('should return string representation with all properties', () {
        // Arrange
        final entity = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Act
        final result = entity.toString();

        // Assert
        expect(result, contains('WishlistItemEntity'));
        expect(result, contains(testId));
        expect(result, contains(testProductId.toString()));
        expect(result, contains(testUserId));
        expect(result, contains(testAddedAt.toString()));
      });
    });

    group('Props', () {
      test('should include all properties in props list', () {
        // Arrange
        final entity = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Act & Assert
        expect(entity.props, [testId, testProductId, testUserId, testAddedAt]);
      });
    });
  });
}
