import 'package:bloc_test/bloc_test.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mock_product_usecase.dart';

void main() {
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late ProductBloc productBloc;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();

    productBloc = ProductBloc(
      getProductsUseCase: mockGetProductsUseCase,
      getProductByIdUseCase: MockGetProductByIdUseCase(),
      searchProductsUseCase: MockSearchProductsUseCase(),
      getCategoriesUseCase: mockGetCategoriesUseCase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  group('Edge cases', () {
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
      'handles empty categories list',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => [testProduct]);
        when(() => mockGetCategoriesUseCase()).thenAnswer((_) async => []);
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchInitialDataEvent()),
      expect: () => [
        ProductLoading(isLoadingCategories: true, isLoadingProducts: true),
        ProductDataLoaded(
          products: [testProduct],
          categories: [],
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'handles pagination with exact page size',
      build: () {
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 0),
        ).thenAnswer((_) async => List.generate(20, (i) => testProduct));
        when(
          () => mockGetProductsUseCase(limit: 20, skip: 20),
        ).thenAnswer((_) async => List.generate(20, (i) => testProduct));
        return productBloc;
      },
      act: (bloc) async {
        bloc.add(FetchProductsEvent());
        await pumpEventQueue();

        bloc.add(FetchProductsEvent(limit: 20, skip: 20, isLoadMore: true));
      },
      skip: 1,
      expect: () => [
        ProductLoading(isLoadMore: true),
        ProductDataLoaded(
          products: List.generate(40, (i) => testProduct),
          categories: [],
          hasReachedMax: false, // Still returning full page, so not reached max
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
          hasReachedMax: false,
        ),
      ],
    );
  });
}
