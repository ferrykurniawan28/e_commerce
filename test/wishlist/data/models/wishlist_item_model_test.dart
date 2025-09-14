import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/features/wishlist/data/models/models.dart';
import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';

void main() {
  group('WishlistItemModel', () {
    const testId = 'user123_1_1699000000000';
    const testProductId = 1;
    const testUserId = 'user123';
    final testAddedAt = DateTime.fromMillisecondsSinceEpoch(1699000000000);

    group('Constructor', () {
      test('should create WishlistItemModel with required parameters', () {
        // Act
        final model = WishlistItemModel(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(model.id, testId);
        expect(model.productId, testProductId);
        expect(model.userId, testUserId);
        expect(model.addedAt, testAddedAt);
      });
    });

    group('fromEntity', () {
      test('should create WishlistItemModel from WishlistItemEntity', () {
        // Arrange
        final entity = WishlistItemEntity(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Act
        final model = WishlistItemModel.fromEntity(entity);

        // Assert
        expect(model.id, entity.id);
        expect(model.productId, entity.productId);
        expect(model.userId, entity.userId);
        expect(model.addedAt, entity.addedAt);
      });
    });

    group('toEntity', () {
      test('should convert WishlistItemModel to WishlistItemEntity', () {
        // Arrange
        final model = WishlistItemModel(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<WishlistItemEntity>());
        expect(entity.id, model.id);
        expect(entity.productId, model.productId);
        expect(entity.userId, model.userId);
        expect(entity.addedAt, model.addedAt);
      });
    });

    group('create factory', () {
      test(
          'should create WishlistItemModel with auto-generated id and current timestamp',
          () {
        // Arrange
        const productId = 123;
        const userId = 'test-user-456';

        // Act
        final model = WishlistItemModel.create(
          productId: productId,
          userId: userId,
        );

        // Assert
        expect(model.productId, productId);
        expect(model.userId, userId);
        expect(model.id, contains('${userId}_${productId}_'));
        expect(model.addedAt, isA<DateTime>());

        // Check that addedAt is recent (within last 5 seconds)
        final now = DateTime.now();
        final difference = now.difference(model.addedAt);
        expect(difference.inSeconds, lessThan(5));
      });

      test('should generate unique ids for different calls', () {
        // Arrange
        const productId = 123;
        const userId = 'test-user-456';

        // Act
        final model1 = WishlistItemModel.create(
          productId: productId,
          userId: userId,
        );

        // Small delay to ensure different timestamp
        Future.delayed(const Duration(milliseconds: 1));

        final model2 = WishlistItemModel.create(
          productId: productId,
          userId: userId,
        );

        // Assert
        expect(model1.id, isNot(equals(model2.id)));
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        final model1 = WishlistItemModel(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final model2 = WishlistItemModel(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        final model1 = WishlistItemModel(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        final model2 = WishlistItemModel(
          id: 'different-id',
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Assert
        expect(model1, isNot(equals(model2)));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        // Arrange
        final model = WishlistItemModel(
          id: testId,
          productId: testProductId,
          userId: testUserId,
          addedAt: testAddedAt,
        );

        // Act
        final result = model.toString();

        // Assert
        expect(result, contains('WishlistItemModel'));
        expect(result, contains(testId));
        expect(result, contains(testProductId.toString()));
        expect(result, contains(testUserId));
        expect(result, contains(testAddedAt.toString()));
      });
    });
  });
}
