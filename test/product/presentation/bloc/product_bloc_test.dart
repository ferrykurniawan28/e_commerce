import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce/core/errors/errors.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mock_product_usecase.dart';

void main() {
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockGetProductByIdUseCase mockGetProductByIdUseCase;
  late MockSearchProductsUseCase mockSearchProductsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late ProductBloc productBloc;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockGetProductByIdUseCase = MockGetProductByIdUseCase();
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();

    productBloc = ProductBloc(
      getProductsUseCase: mockGetProductsUseCase,
      getProductByIdUseCase: mockGetProductByIdUseCase,
      searchProductsUseCase: mockSearchProductsUseCase,
      getCategoriesUseCase: mockGetCategoriesUseCase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  group('ProductBloc', () {
    test('initial state is ProductInitial', () {
      expect(productBloc.state, equals(ProductInitial()));
    });

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductDataLoaded] when FetchInitialDataEvent is successful',
      build: () {
        when(
          () => mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => testCategories);
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => [testProduct]);
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchInitialDataEvent()),
      expect: () => [
        ProductLoading(isLoadingCategories: true, isLoadingProducts: true),
        ProductDataLoaded(
          products: [testProduct],
          categories: testCategories,
          hasReachedMax:
              true, // Changed to true because we only return 1 product (less than page size 20)
        ),
      ],
      verify: (_) {
        verify(() => mockGetCategoriesUseCase()).called(1);
        verify(() => mockGetProductsUseCase(limit: 20, skip: 0)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when FetchInitialDataEvent fails',
      build: () {
        when(
          () => mockGetCategoriesUseCase(),
        ).thenThrow(ServerException(message: 'Server error'));
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchInitialDataEvent()),
      expect: () => [
        ProductLoading(isLoadingCategories: true, isLoadingProducts: true),
        ProductError(message: 'Server error'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductDataLoaded] when FetchProductsEvent is successful',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => [testProduct]);
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductsEvent()),
      expect: () => [
        ProductLoading(),
        ProductDataLoaded(
          products: [testProduct],
          categories: [],
          hasReachedMax:
              true, // Changed to true because we only return 1 product
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductDataLoaded] when FetchProductsEvent with full page',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => List.generate(20, (index) => testProduct));
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductsEvent()),
      expect: () => [
        ProductLoading(),
        ProductDataLoaded(
          products: List.generate(20, (index) => testProduct),
          categories: [],
          hasReachedMax: false, // False because we returned exactly page size
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when FetchProductsEvent fails',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenThrow(NetworkException(message: 'Network error'));
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductsEvent()),
      expect: () => [
        ProductLoading(),
        ProductError(message: 'Network error', isNetworkError: true),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductSearchLoaded] when SearchProductsEvent is successful',
      build: () {
        when(
          () => mockSearchProductsUseCase('test'),
        ).thenAnswer((_) async => [testProduct]);
        return productBloc;
      },
      act: (bloc) => bloc.add(SearchProductsEvent(query: 'test')),
      expect: () => [
        ProductLoading(),
        ProductSearchLoaded(products: [testProduct], query: 'test'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductDetailLoaded] when FetchProductByIdEvent is successful',
      build: () {
        when(
          () => mockGetProductByIdUseCase(1),
        ).thenAnswer((_) async => testProduct);
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductByIdEvent(id: 1)),
      expect: () => [
        ProductLoading(),
        ProductDetailLoaded(product: testProduct),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductDataLoaded] when FetchCategoriesEvent is successful',
      build: () {
        when(
          () => mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => testCategories);
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchCategoriesEvent()),
      expect: () => [
        ProductLoading(isLoadingCategories: true),
        ProductDataLoaded(
          products: [],
          categories: testCategories,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits proper states when FilterProductsByCategoryEvent is successful',
      build: () {
        when(
          () => mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => testCategories);
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => [testProduct]);
        when(
          () => mockGetProductsUseCase(
            limit: 20,
            skip: 0,
            category: 'electronics',
          ),
        ).thenAnswer((_) async => [testProduct]);
        return productBloc;
      },
      act: (bloc) async {
        // First load initial data
        bloc.add(FetchInitialDataEvent());
        await pumpEventQueue();

        // Then apply filter
        bloc.add(FilterProductsByCategoryEvent(category: testCategory));
      },
      expect: () => [
        // Initial data loading
        ProductLoading(isLoadingCategories: true, isLoadingProducts: true),
        ProductDataLoaded(
          products: [testProduct],
          categories: testCategories,
          hasReachedMax: true,
        ),
        // Filter loading
        ProductLoading(isLoadingProducts: true),
        ProductDataLoaded(
          products: [testProduct],
          categories: testCategories,
          selectedCategory: testCategory,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'ClearSearchEvent with empty products reloads initial data',
      build: () {
        when(
          () => mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => [testCategory]);
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => [testProduct]);
        return productBloc;
      },
      act: (bloc) => bloc.add(ClearSearchEvent()),
      expect: () => [
        ProductLoading(isLoadingCategories: true, isLoadingProducts: true),
        ProductDataLoaded(
          products: [testProduct],
          categories: [testCategory],
          hasReachedMax: true, // Changed to true
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits proper states when loadMoreProducts is called',
      build: () {
        // First call returns full page (20 products)
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => List.generate(20, (i) => testProduct));
        // Second call returns partial page (10 products) indicating end of data
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 20),
        ).thenAnswer((_) async => List.generate(10, (i) => testProduct));
        return productBloc;
      },
      act: (bloc) async {
        // First load initial data
        bloc.add(FetchProductsEvent());
        await pumpEventQueue();

        // Then load more
        bloc.loadMoreProducts();
      },
      expect: () => [
        // Initial load states
        ProductLoading(),
        ProductDataLoaded(
          products: List.generate(20, (i) => testProduct),
          categories: [],
          hasReachedMax: false, // False because we got exactly 20 products
        ),
        // Load more states
        ProductLoading(isLoadMore: true),
        ProductDataLoaded(
          products: List.generate(30, (i) => testProduct), // 20 + 10
          categories: [],
          hasReachedMax:
              true, // True because we only got 10 out of 20 requested
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'handles empty products list',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => []);
        when(
          () => mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => [testCategory]);
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchInitialDataEvent()),
      expect: () => [
        ProductLoading(isLoadingCategories: true, isLoadingProducts: true),
        ProductDataLoaded(
          products: [],
          categories: [testCategory],
          hasReachedMax: true, // Empty list means we've reached max
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits proper states when loadMoreProducts is called',
      setUp: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => List.generate(20, (i) => testProduct));
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 20),
        ).thenAnswer((_) async => List.generate(10, (i) => testProduct));
      },
      build: () => productBloc,
      act: (bloc) async {
        bloc.add(FetchProductsEvent());
        await pumpEventQueue();

        bloc.loadMoreProducts();
      },
      skip: 2, // Skip the first 2 states (loading and initial data loaded)
      expect: () => [
        ProductLoading(isLoadMore: true),
        ProductDataLoaded(
          products: List.generate(30, (i) => testProduct),
          categories: [],
          hasReachedMax: true,
        ),
      ],
    );
  });

  group('Error handling', () {
    blocTest<ProductBloc, ProductState>(
      'handles NetworkException with isNetworkError = true',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenThrow(NetworkException(message: 'No internet'));
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductsEvent()),
      expect: () => [
        ProductLoading(),
        ProductError(message: 'No internet', isNetworkError: true),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'handles ServerException with isNetworkError = false',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenThrow(ServerException(message: 'Server down'));
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductsEvent()),
      expect: () => [
        ProductLoading(),
        ProductError(message: 'Server down', isNetworkError: false),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'handles generic exceptions',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenThrow(Exception('Unexpected error'));
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProductsEvent()),
      expect: () => [
        ProductLoading(),
        ProductError(message: 'Failed to fetch products'),
      ],
    );
  });
}
