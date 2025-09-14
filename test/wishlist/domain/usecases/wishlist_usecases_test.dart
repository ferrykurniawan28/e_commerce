import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';
import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/usecases.dart';

// Mock repository
class MockWishlistRepository extends Mock implements WishlistRepository {}

void main() {
  late MockWishlistRepository mockRepository;
  late AddToWishlistUseCase addToWishlistUseCase;
  late RemoveFromWishlistUseCase removeFromWishlistUseCase;
  late GetUserWishlistUseCase getUserWishlistUseCase;
  late IsInWishlistUseCase isInWishlistUseCase;
  late ToggleWishlistUseCase toggleWishlistUseCase;
  late ClearUserWishlistUseCase clearUserWishlistUseCase;

  setUp(() {
    mockRepository = MockWishlistRepository();
    addToWishlistUseCase = AddToWishlistUseCase(repository: mockRepository);
    removeFromWishlistUseCase =
        RemoveFromWishlistUseCase(repository: mockRepository);
    getUserWishlistUseCase = GetUserWishlistUseCase(repository: mockRepository);
    isInWishlistUseCase = IsInWishlistUseCase(repository: mockRepository);
    toggleWishlistUseCase = ToggleWishlistUseCase(repository: mockRepository);
    clearUserWishlistUseCase =
        ClearUserWishlistUseCase(repository: mockRepository);
  });

  group('AddToWishlistUseCase', () {
    test('should call repository addToWishlist with correct parameters',
        () async {
      // Arrange
      const productId = 1;
      const userId = 'test-user-123';
      when(() => mockRepository.addToWishlist(
            productId: any(named: 'productId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async {});

      // Act
      await addToWishlistUseCase.call(productId: productId, userId: userId);

      // Assert
      verify(() => mockRepository.addToWishlist(
            productId: productId,
            userId: userId,
          )).called(1);
    });
  });

  group('RemoveFromWishlistUseCase', () {
    test('should call repository removeFromWishlist with correct parameters',
        () async {
      // Arrange
      const productId = 1;
      const userId = 'test-user-123';
      when(() => mockRepository.removeFromWishlist(
            productId: any(named: 'productId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async {});

      // Act
      await removeFromWishlistUseCase.call(
          productId: productId, userId: userId);

      // Assert
      verify(() => mockRepository.removeFromWishlist(
            productId: productId,
            userId: userId,
          )).called(1);
    });
  });

  group('GetUserWishlistUseCase', () {
    test(
        'should call repository getUserWishlist and return list of wishlist items',
        () async {
      // Arrange
      const userId = 'test-user-123';
      final mockWishlistItems = [
        WishlistItemEntity(
          id: 'test-id-1',
          productId: 1,
          userId: userId,
          addedAt: DateTime.now(),
        ),
        WishlistItemEntity(
          id: 'test-id-2',
          productId: 2,
          userId: userId,
          addedAt: DateTime.now(),
        ),
      ];

      when(() => mockRepository.getUserWishlist(any()))
          .thenAnswer((_) async => mockWishlistItems);

      // Act
      final result = await getUserWishlistUseCase.call(userId);

      // Assert
      verify(() => mockRepository.getUserWishlist(userId)).called(1);
      expect(result, equals(mockWishlistItems));
      expect(result.length, equals(2));
    });
  });

  group('IsInWishlistUseCase', () {
    test('should call repository isInWishlist and return boolean result',
        () async {
      // Arrange
      const productId = 1;
      const userId = 'test-user-123';
      when(() => mockRepository.isInWishlist(
            productId: any(named: 'productId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => true);

      // Act
      final result = await isInWishlistUseCase.call(
        productId: productId,
        userId: userId,
      );

      // Assert
      verify(() => mockRepository.isInWishlist(
            productId: productId,
            userId: userId,
          )).called(1);
      expect(result, equals(true));
    });
  });

  group('ToggleWishlistUseCase', () {
    test('should call repository toggleWishlist and return boolean result',
        () async {
      // Arrange
      const productId = 1;
      const userId = 'test-user-123';
      when(() => mockRepository.toggleWishlist(
            productId: any(named: 'productId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => true);

      // Act
      final result = await toggleWishlistUseCase.call(
        productId: productId,
        userId: userId,
      );

      // Assert
      verify(() => mockRepository.toggleWishlist(
            productId: productId,
            userId: userId,
          )).called(1);
      expect(result, equals(true));
    });

    test('should return false when item is removed from wishlist', () async {
      // Arrange
      const productId = 1;
      const userId = 'test-user-123';
      when(() => mockRepository.toggleWishlist(
            productId: any(named: 'productId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => false);

      // Act
      final result = await toggleWishlistUseCase.call(
        productId: productId,
        userId: userId,
      );

      // Assert
      expect(result, equals(false));
    });
  });

  group('ClearUserWishlistUseCase', () {
    test('should call repository clearUserWishlist with correct userId',
        () async {
      // Arrange
      const userId = 'test-user-123';
      when(() => mockRepository.clearUserWishlist(any()))
          .thenAnswer((_) async {});

      // Act
      await clearUserWishlistUseCase.call(userId);

      // Assert
      verify(() => mockRepository.clearUserWishlist(userId)).called(1);
    });
  });

  group('Use Case Integration', () {
    test('should work together in a typical workflow', () async {
      // Arrange
      const productId = 1;
      const userId = 'test-user-123';

      // Mock the workflow
      when(() => mockRepository.isInWishlist(
            productId: productId,
            userId: userId,
          )).thenAnswer((_) async => false);

      when(() => mockRepository.addToWishlist(
            productId: productId,
            userId: userId,
          )).thenAnswer((_) async {});

      when(() => mockRepository.getUserWishlist(userId))
          .thenAnswer((_) async => [
                WishlistItemEntity(
                  id: 'test-id',
                  productId: productId,
                  userId: userId,
                  addedAt: DateTime.now(),
                ),
              ]);

      // Act & Assert
      // Check if product is in wishlist (should be false initially)
      final isInWishlistInitially = await isInWishlistUseCase.call(
        productId: productId,
        userId: userId,
      );
      expect(isInWishlistInitially, equals(false));

      // Add to wishlist
      await addToWishlistUseCase.call(productId: productId, userId: userId);

      // Get user wishlist
      final wishlist = await getUserWishlistUseCase.call(userId);
      expect(wishlist.length, equals(1));
      expect(wishlist.first.productId, equals(productId));

      // Verify all calls were made
      verify(() => mockRepository.isInWishlist(
            productId: productId,
            userId: userId,
          )).called(1);
      verify(() => mockRepository.addToWishlist(
            productId: productId,
            userId: userId,
          )).called(1);
      verify(() => mockRepository.getUserWishlist(userId)).called(1);
    });
  });
}
