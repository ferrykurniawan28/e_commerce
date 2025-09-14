import 'package:hive_flutter/hive_flutter.dart';
import 'package:e_commerce/features/product/data/models/models.dart';

class HiveService {
  static const String _productsBoxName = 'products';
  static const String _categoriesBoxName = 'categories';

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

    // Open boxes
    await Hive.openBox<ProductModel>(_productsBoxName);
    await Hive.openBox<String>(_categoriesBoxName);
  }

  // Product operations
  static Box<ProductModel> get productsBox =>
      Hive.box<ProductModel>(_productsBoxName);
  static Box<String> get categoriesBox => Hive.box<String>(_categoriesBoxName);

  // Cache products
  static Future<void> cacheProducts(List<ProductModel> products) async {
    final box = productsBox;
    await box.clear(); // Clear old data
    for (final product in products) {
      await box.put(product.id, product); // Use product ID as key
    }
  }

  // Get cached products
  static List<ProductModel> getCachedProducts() {
    final box = productsBox;
    return box.values.toList();
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

  // Check if cache is empty
  static bool get hasProducts => productsBox.isNotEmpty;
  static bool get hasCategories => categoriesBox.isNotEmpty;

  // Clear cache
  static Future<void> clearCache() async {
    await productsBox.clear();
    await categoriesBox.clear();
  }

  // Close all boxes (call when app closes)
  static Future<void> close() async {
    await Hive.close();
  }
}
