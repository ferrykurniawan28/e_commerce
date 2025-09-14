import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class MockGetProductByIdUseCase extends Mock implements GetProductByIdUseCase {}

class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

// Test data
final testProduct = ProductEntity(
  id: 1,
  title: 'Test Product',
  description: 'Test Description',
  category: 'electronics',
  price: 99.99,
  discountPercentage: 10.0,
  rating: 4.5,
  stock: 100,
  tags: ['test', 'electronic'],
  brand: 'Test Brand',
  sku: 'TEST123',
  weight: 500,
  dimensions: DimensionsEntity(width: 10, height: 5, depth: 3),
  warrantyInformation: '1 year',
  shippingInformation: 'Free shipping',
  availabilityStatus: 'In Stock',
  reviews: [],
  returnPolicy: '30 days',
  minimumOrderQuantity: 1,
  meta: MetaEntity(
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    barcode: '123456789',
    qrCode: 'QR123456',
  ),
  thumbnail: 'https://example.com/thumbnail.jpg',
  images: ['https://example.com/image1.jpg'],
);

final testCategory = CategoryEntity(
  slug: 'electronics',
  name: 'Electronics',
  url: 'https://dummyjson.com/products/category/electronics',
);

final testCategories = [
  CategoryEntity(
    slug: 'electronics',
    name: 'Electronics',
    url: 'https://dummyjson.com/products/category/electronics',
  ),
  CategoryEntity(
    slug: 'clothing',
    name: 'Clothing',
    url: 'https://dummyjson.com/products/category/clothing',
  ),
];
