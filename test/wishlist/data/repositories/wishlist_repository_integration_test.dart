// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:e_commerce/features/wishlist/data/repositories/repositories.dart';
// import 'package:e_commerce/features/wishlist/data/models/models.dart';
// import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';

// void main() {
//   group('WishlistRepositoryImpl Integration Tests', () {
//     late WishlistRepositoryImpl repository;
//     late Box<WishlistItemModel> testBox;

//     setUpAll(() async {
//       // Initialize Hive for testing
//       Hive.init('./test/hive_test_db');

//       // Register adapter if not already registered
//       if (!Hive.isAdapterRegistered(4)) {
//         Hive.registerAdapter(WishlistItemModelAdapter());
//       }
//     });

//     setUp(() async {
//       // Open a test box
//       testBox = await Hive.openBox<WishlistItemModel>('test_wishlist');
//       repository = WishlistRepositoryImpl();
//     });

//     tearDown(() async {
//       // Clear the test box after each test
//       await testBox.clear();
//       await testBox.close();
//     });

//     tearDownAll(() async {
//       // Clean up Hive
//       await Hive.deleteFromDisk();
//     });

//     group('Repository Interface Tests', () {
//       test('should implement all methods from WishlistRepository interface',
//           () {
//         // Assert that the repository implements the interface
//         expect(repository, isA<WishlistRepositoryImpl>());
//         expect(repository.addToWishlist, isA<Function>());
//         expect(repository.removeFromWishlist, isA<Function>());
//         expect(repository.getUserWishlist, isA<Function>());
//         expect(repository.isInWishlist, isA<Function>());
//         expect(repository.clearUserWishlist, isA<Function>());
//         expect(repository.toggleWishlist, isA<Function>());
//       });
//     });

//     group('Data Conversion Tests', () {
//       test('should convert models to entities correctly', () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user-123';

//         // Act
//         await repository.addToWishlist(productId: productId, userId: userId);
//         final wishlist = await repository.getUserWishlist(userId);

//         // Assert
//         expect(wishlist, isA<List<WishlistItemEntity>>());
//         expect(wishlist.length, equals(1));
//         expect(wishlist.first.productId, equals(productId));
//         expect(wishlist.first.userId, equals(userId));
//         expect(wishlist.first.id, isA<String>());
//         expect(wishlist.first.addedAt, isA<DateTime>());
//       });
//     });

//     group('Business Logic Tests', () {
//       test('toggleWishlist should add when not present', () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user-123';

//         // Verify initially not in wishlist
//         final initialStatus = await repository.isInWishlist(
//           productId: productId,
//           userId: userId,
//         );
//         expect(initialStatus, equals(false));

//         // Act
//         final result = await repository.toggleWishlist(
//           productId: productId,
//           userId: userId,
//         );

//         // Assert
//         expect(result, equals(true)); // Added to wishlist

//         final finalStatus = await repository.isInWishlist(
//           productId: productId,
//           userId: userId,
//         );
//         expect(finalStatus, equals(true));
//       });

//       test('toggleWishlist should remove when present', () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user-123';

//         // Add to wishlist first
//         await repository.addToWishlist(productId: productId, userId: userId);

//         final initialStatus = await repository.isInWishlist(
//           productId: productId,
//           userId: userId,
//         );
//         expect(initialStatus, equals(true));

//         // Act
//         final result = await repository.toggleWishlist(
//           productId: productId,
//           userId: userId,
//         );

//         // Assert
//         expect(result, equals(false)); // Removed from wishlist

//         final finalStatus = await repository.isInWishlist(
//           productId: productId,
//           userId: userId,
//         );
//         expect(finalStatus, equals(false));
//       });

//       test('should isolate wishlist by userId', () async {
//         // Arrange
//         const productId = 1;
//         const userId1 = 'user-123';
//         const userId2 = 'user-456';

//         // Act
//         await repository.addToWishlist(productId: productId, userId: userId1);

//         // Assert
//         final user1Wishlist = await repository.getUserWishlist(userId1);
//         final user2Wishlist = await repository.getUserWishlist(userId2);

//         expect(user1Wishlist.length, equals(1));
//         expect(user2Wishlist.length, equals(0));

//         final isInUser1Wishlist = await repository.isInWishlist(
//           productId: productId,
//           userId: userId1,
//         );
//         final isInUser2Wishlist = await repository.isInWishlist(
//           productId: productId,
//           userId: userId2,
//         );

//         expect(isInUser1Wishlist, equals(true));
//         expect(isInUser2Wishlist, equals(false));
//       });

//       test('should clear only specific user wishlist', () async {
//         // Arrange
//         const productId1 = 1;
//         const productId2 = 2;
//         const userId1 = 'user-123';
//         const userId2 = 'user-456';

//         await repository.addToWishlist(productId: productId1, userId: userId1);
//         await repository.addToWishlist(productId: productId2, userId: userId1);
//         await repository.addToWishlist(productId: productId1, userId: userId2);

//         // Act
//         await repository.clearUserWishlist(userId1);

//         // Assert
//         final user1Wishlist = await repository.getUserWishlist(userId1);
//         final user2Wishlist = await repository.getUserWishlist(userId2);

//         expect(user1Wishlist.length, equals(0));
//         expect(user2Wishlist.length, equals(1));
//       });
//     });

//     group('Error Handling', () {
//       test('should handle empty wishlist gracefully', () async {
//         // Arrange
//         const userId = 'empty-user';

//         // Act
//         final wishlist = await repository.getUserWishlist(userId);
//         final isInWishlist = await repository.isInWishlist(
//           productId: 999,
//           userId: userId,
//         );

//         // Assert
//         expect(wishlist, isEmpty);
//         expect(isInWishlist, equals(false));
//       });

//       test('should handle multiple operations on same product gracefully',
//           () async {
//         // Arrange
//         const productId = 1;
//         const userId = 'test-user';

//         // Act & Assert - Multiple adds should not create duplicates
//         await repository.addToWishlist(productId: productId, userId: userId);
//         await repository.addToWishlist(productId: productId, userId: userId);

//         final wishlist = await repository.getUserWishlist(userId);
//         expect(wishlist.length, equals(1));

//         // Multiple removes should not cause errors
//         await repository.removeFromWishlist(
//             productId: productId, userId: userId);
//         await repository.removeFromWishlist(
//             productId: productId, userId: userId);

//         final emptyWishlist = await repository.getUserWishlist(userId);
//         expect(emptyWishlist.length, equals(0));
//       });
//     });
//   });
// }
