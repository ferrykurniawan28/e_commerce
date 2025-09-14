import 'package:hive_flutter/hive_flutter.dart';
import 'package:e_commerce/features/product/data/models/models.dart';
import 'package:e_commerce/features/wishlist/data/models/models.dart';
import 'package:e_commerce/features/cart/data/models/models.dart';

class HiveService {
  static const String _productsBoxName = 'products';
  static const String _categoriesBoxName = 'categories';
  static const String _wishlistBoxName = 'wishlist';
  static const String _cartBoxName = 'cart';

  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DimensionsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MetaModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ReviewModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WishlistItemModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(CartItemModelAdapter());
    }

    // Open boxes
    await Hive.openBox<ProductModel>(_productsBoxName);
    await Hive.openBox<String>(_categoriesBoxName);
    await Hive.openBox<WishlistItemModel>(_wishlistBoxName);
    await Hive.openBox<CartItemModel>(_cartBoxName);
  }

  // Product operations
  static Box<ProductModel> get productsBox =>
      Hive.box<ProductModel>(_productsBoxName);
  static Box<String> get categoriesBox => Hive.box<String>(_categoriesBoxName);
  static Box<CartItemModel> get cartBox =>
      Hive.box<CartItemModel>(_cartBoxName);
  static Box<WishlistItemModel> get wishlistBox =>
      Hive.box<WishlistItemModel>(_wishlistBoxName);

  // Cache products (for first page - replaces all)
  static Future<void> cacheProducts(List<ProductModel> products) async {
    final box = productsBox;
    final oldCount = box.length;
    await box.clear(); // Clear old data only for first page load
    for (final product in products) {
      await box.put(product.id, product); // Use product ID as key
    }
    print(
        'HiveService: Replaced $oldCount products with ${products.length} new products');
  }

  // Cache additional products (for pagination - adds without clearing, updates if exists)
  static Future<void> cacheAdditionalProducts(
      List<ProductModel> products) async {
    final box = productsBox;
    int newProducts = 0;
    int updatedProducts = 0;

    for (final product in products) {
      final existed = box.containsKey(product.id);
      await box.put(
          product.id, product); // Use product ID as key - will update if exists

      if (existed) {
        updatedProducts++;
      } else {
        newProducts++;
      }
    }

    print(
        'HiveService: Cached $newProducts new products, updated $updatedProducts existing products');
  }

  // Get cached products (returns unique products by ID)
  static List<ProductModel> getCachedProducts() {
    final box = productsBox;
    return box.values.toList();
  }

  // Debug method: Get products with their keys to check for duplicates
  static Map<int, ProductModel> getCachedProductsWithKeys() {
    final box = productsBox;
    final Map<int, ProductModel> productsMap = {};
    for (final key in box.keys) {
      final product = box.get(key);
      if (product != null) {
        productsMap[key as int] = product;
      }
    }
    return productsMap;
  }

  // Method to ensure no duplicate products (cleanup if needed)
  static Future<void> cleanupDuplicateProducts() async {
    final box = productsBox;
    final uniqueProducts = <int, ProductModel>{};

    // Collect all unique products by ID
    for (final product in box.values) {
      uniqueProducts[product.id] = product;
    }

    // Clear and re-add only unique products
    await box.clear();
    for (final entry in uniqueProducts.entries) {
      await box.put(entry.key, entry.value);
    }
  }

  // Cache single product
  static Future<void> cacheProduct(ProductModel product) async {
    final box = productsBox;
    await box.put(product.id, product);
  }

  // Get cached product by ID
  static ProductModel? getCachedProduct(int id) {
    final box = productsBox;
    return box.get(id);
  }

  // Cache categories
  static Future<void> cacheCategories(List<String> categories) async {
    final box = categoriesBox;
    await box.clear();
    for (int i = 0; i < categories.length; i++) {
      await box.put(i, categories[i]);
    }
  }

  // Get cached categories
  static List<String> getCachedCategories() {
    final box = categoriesBox;
    return box.values.toList();
  }

  // Wishlist operations
  // Add item to wishlist
  static Future<void> addToWishlist(WishlistItemModel item) async {
    final box = wishlistBox;
    // Use composite key: userId_productId to ensure uniqueness per user
    final key = '${item.userId}_${item.productId}';
    await box.put(key, item);
    print(
        'HiveService: Added product ${item.productId} to wishlist for user ${item.userId}');
  }

  // Remove item from wishlist
  static Future<void> removeFromWishlist({
    required String userId,
    required int productId,
  }) async {
    final box = wishlistBox;
    final key = '${userId}_${productId}';
    await box.delete(key);
    print(
        'HiveService: Removed product $productId from wishlist for user $userId');
  }

  // Get user's wishlist items
  static List<WishlistItemModel> getUserWishlist(String userId) {
    final box = wishlistBox;
    return box.values.where((item) => item.userId == userId).toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Sort by newest first
  }

  // Check if product is in user's wishlist
  static bool isInWishlist({
    required String userId,
    required int productId,
  }) {
    final box = wishlistBox;
    final key = '${userId}_${productId}';
    return box.containsKey(key);
  }

  // Clear user's wishlist (when user logs out)
  static Future<void> clearUserWishlist(String userId) async {
    final box = wishlistBox;
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      final item = box.get(key);
      if (item != null && item.userId == userId) {
        keysToDelete.add(key.toString());
      }
    }

    await box.deleteAll(keysToDelete);
    print(
        'HiveService: Cleared wishlist for user $userId (${keysToDelete.length} items)');
  }

  // Cart operations
  // Add item to cart
  static Future<void> addToCart(CartItemModel item) async {
    final box = cartBox;
    // Use composite key: userId_productId to ensure uniqueness per user
    final key = '${item.userId}_${item.productId}';
    await box.put(key, item);
    print(
        'HiveService: Added product ${item.productId} to cart for user ${item.userId}');
  }

  // Remove item from cart
  static Future<void> removeFromCart({
    required String userId,
    required int productId,
  }) async {
    final box = cartBox;
    final key = '${userId}_${productId}';
    await box.delete(key);
    print('HiveService: Removed product $productId from cart for user $userId');
  }

  // Get user's cart items
  static List<CartItemModel> getUserCart(String userId) {
    final box = cartBox;
    return box.values.where((item) => item.userId == userId).toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Sort by newest first
  }

  // Check if product is in user's cart
  static bool isInCart({
    required String userId,
    required int productId,
  }) {
    final box = cartBox;
    final key = '${userId}_${productId}';
    return box.containsKey(key);
  }

  // Get cart item
  static CartItemModel? getCartItem({
    required String userId,
    required int productId,
  }) {
    final box = cartBox;
    final key = '${userId}_${productId}';
    return box.get(key);
  }

  // Update cart item
  static Future<void> updateCartItem(CartItemModel item) async {
    final box = cartBox;
    final key = '${item.userId}_${item.productId}';
    await box.put(key, item);
    print(
        'HiveService: Updated product ${item.productId} in cart for user ${item.userId}');
  }

  // Clear user's cart (when user logs out or clears cart)
  static Future<void> clearUserCart(String userId) async {
    final box = cartBox;
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      final item = box.get(key);
      if (item != null && item.userId == userId) {
        keysToDelete.add(key.toString());
      }
    }

    await box.deleteAll(keysToDelete);
    print(
        'HiveService: Cleared cart for user $userId (${keysToDelete.length} items)');
  }

  // Get cart item count for user
  static int getCartItemCount(String userId) {
    final box = cartBox;
    return box.values.where((item) => item.userId == userId).length;
  }

  // Get total quantity in cart for user
  static int getTotalCartQuantity(String userId) {
    final box = cartBox;
    final userItems = box.values.where((item) => item.userId == userId);
    return userItems.fold(0, (total, item) => total + item.quantity);
  }

  // Check if cache is empty
  static bool get hasProducts => productsBox.isNotEmpty;
  static bool get hasCategories => categoriesBox.isNotEmpty;
  static bool hasWishlistForUser(String userId) =>
      wishlistBox.values.any((item) => item.userId == userId);

  // Clear cache
  static Future<void> clearCache() async {
    await productsBox.clear();
    await categoriesBox.clear();
  }

  // Clear all cache including wishlist and cart
  static Future<void> clearAllCache() async {
    await productsBox.clear();
    await categoriesBox.clear();
    await wishlistBox.clear();
    await cartBox.clear();
  }

  // DEBUG ONLY: Clear all data on startup
  static Future<void> clearAllDataForDebug() async {
    print('DEBUG: Clearing all Hive data on startup...');
    await productsBox.clear();
    await categoriesBox.clear();
    await wishlistBox.clear();
    await cartBox.clear();
    print('DEBUG: All Hive data cleared!');
  }

  // Close all boxes (call when app closes)
  static Future<void> close() async {
    await Hive.close();
  }
}
