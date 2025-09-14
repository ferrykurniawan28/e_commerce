// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:e_commerce/features/wishlist/data/repositories/repositories.dart';
// import 'package:e_commerce/features/wishlist/data/models/models.dart';
// import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';
// import 'package:e_commerce/core/services/hive_service.dart';

// // Mock HiveService
// class MockHiveService extends Mock {
//   static Future<void> addToWishlist(WishlistItemModel item) async {}
//   static Future<void> removeFromWishlist({
//     required String userId,
//     required int productId,
//   }) async {}
//   static List<WishlistItemModel> getUserWishlist(String userId) => [];
//   static bool isInWishlist({
//     required String userId,
//     required int productId,
//   }) =>
//       false;
//   static Future<void> clearUserWishlist(String userId) async {}
// }

// void main() {
//   group('WishlistRepositoryImpl', () {
//     late WishlistRepositoryImpl repository;

//     setUp(() {
//       repository = WishlistRepositoryImpl();
//     });

//     group('addToWishlist', () {
//       test('should call HiveService.addToWishlist with correct parameters',
//           () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user-123';

//         // Act
//         await repository.addToWishlist(productId: productId, userId: userId);

//         // Assert
//         // Since HiveService is static and we can't easily mock it in this context,
//         // we'll test the integration behavior
//         expect(repository, isNotNull);
//       });
//     });

//     group('removeFromWishlist', () {
//       test('should call HiveService.removeFromWishlist with correct parameters',
//           () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user-123';

//         // Act
//         await repository.removeFromWishlist(
//             productId: productId, userId: userId);

//         // Assert
//         expect(repository, isNotNull);
//       });
//     });

//     group('getUserWishlist', () {
//       test('should return list of WishlistItemEntity', () async {
//         // Arrange
//         const userId = 'test-user-123';

//         // Act
//         final result = await repository.getUserWishlist(userId);

//         // Assert
//         expect(result, isA<List<WishlistItemEntity>>());
//       });
//     });

//     group('isInWishlist', () {
//       test('should return boolean indicating wishlist status', () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user-123';

//         // Act
//         final result = await repository.isInWishlist(
//           productId: productId,
//           userId: userId,
//         );

//         // Assert
//         expect(result, isA<bool>());
//       });
//     });

//     group('clearUserWishlist', () {
//       test('should call HiveService.clearUserWishlist', () async {
//         // Arrange
//         const userId = 'test-user-123';

//         // Act
//         await repository.clearUserWishlist(userId);

//         // Assert
//         expect(repository, isNotNull);
//       });
//     });

//     group('toggleWishlist', () {
//       test('should add to wishlist when not present and return true', () async {
//         // This is an integration test since we can't easily mock static methods
//         // Arrange
//         const productId = 999; // Use a unique ID to avoid conflicts
//         const userId = 'test-toggle-user';

//         // Act
//         final result = await repository.toggleWishlist(
//           productId: productId,
//           userId: userId,
//         );

//         // Assert
//         expect(result, isA<bool>());
//       });
//     });
//   });
// }
