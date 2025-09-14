// features/product/presentation/bloc/product_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/errors/errors.dart';
import 'package:e_commerce/core/services/hive_service.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  // For pagination
  final List<ProductEntity> _allProducts = [];
  int _currentSkip = 0;
  final int _totalProducts = 0;
  final int _pageSize = 20;
  String? _currentCategorySlug;

  ProductBloc({
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
    required this.searchProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FetchProductByIdEvent>(_onFetchProductById);
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<ClearSearchEvent>(_onClearSearch);
    on<FetchInitialDataEvent>(_onFetchInitialData);
    on<FilterProductsByCategoryEvent>(_onFilterProductsByCategory);
    on<ClearFilterEvent>(_onClearFilter);
  }

  Future<void> _onFetchInitialData(
    FetchInitialDataEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading(isLoadingCategories: true, isLoadingProducts: true));

      // Fetch both categories and products in parallel
      final results = await Future.wait([
        getCategoriesUseCase(),
        getProductsUseCase(limit: _pageSize, skip: 0),
      ]);

      final categories = results[0] as List<CategoryEntity>;
      final products = results[1] as List<ProductEntity>;

      _allProducts.clear();
      _allProducts.addAll(products);
      _currentSkip = products.length;

      // Fix: hasReachedMax should be true if we get fewer products than page size
      final hasReachedMax = products.length < _pageSize;

      print(
        'Fetched ${products.length} products and ${categories.length} categories',
      );
      print('Has reached max: $hasReachedMax');
      print('categories: ${categories.map((c) => c.url).toList()}');

      emit(
        ProductDataLoaded(
          products: List.from(_allProducts),
          categories: categories,
          hasReachedMax: hasReachedMax,
        ),
      );
    } on NetworkException catch (e) {
      // Try to load from cache when network fails
      try {
        print('Network failed, trying cache...');

        if (HiveService.hasProducts || HiveService.hasCategories) {
          final cachedProducts = HiveService.hasProducts
              ? HiveService.getCachedProducts()
                  .map((model) => model.toEntity())
                  .toList()
              : <ProductEntity>[];

          final cachedCategories = HiveService.hasCategories
              ? HiveService.getCachedCategories()
                  .map((name) => CategoryEntity(
                      name: name,
                      slug: name.toLowerCase().replaceAll(' ', '-'),
                      url: ''))
                  .toList()
              : <CategoryEntity>[];

          _allProducts.clear();
          _allProducts.addAll(cachedProducts);
          _currentSkip = cachedProducts.length;

          emit(
            ProductDataLoaded(
              products: List.from(_allProducts),
              categories: cachedCategories,
              hasReachedMax: cachedProducts.length < _pageSize,
            ),
          );

          print(
              'Loaded ${cachedProducts.length} products and ${cachedCategories.length} categories from cache');
        } else {
          emit(ProductError(
              message: 'No internet connection and no cached data available',
              isNetworkError: true));
        }
      } catch (cacheError) {
        print('Cache loading failed: $cacheError');
        emit(ProductError(message: e.message, isNetworkError: true));
      }
    } on ServerException catch (e) {
      emit(ProductError(message: e.message));
    } catch (e) {
      emit(ProductError(message: 'Failed to load initial data'));
    }
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (event.isLoadMore) {
        emit(ProductLoading(isLoadMore: true));
      } else {
        emit(ProductLoading());
        if (event.category != _currentCategorySlug) {
          _allProducts.clear();
          _currentSkip = 0;
        }
      }

      final products = await getProductsUseCase(
        limit: event.limit,
        skip: event.skip,
        category: event.category,
      );

      if (event.isLoadMore) {
        // For pagination, add new products to existing list
        _allProducts.addAll(products);
        _currentSkip += products.length;
      } else {
        // For fresh load (category change, initial load), replace all products
        _allProducts.clear();
        _allProducts.addAll(products);
        _currentSkip = event.skip + products.length;
      }

      // Fix: hasReachedMax should be true if we get fewer products than requested
      final hasReachedMax = products.length < event.limit;

      // Get current categories if we're in a loaded state
      List<CategoryEntity> currentCategories = [];
      if (state is ProductDataLoaded) {
        currentCategories = (state as ProductDataLoaded).categories;
      }

      emit(
        ProductDataLoaded(
          products: List.from(_allProducts),
          categories: currentCategories,
          hasReachedMax: hasReachedMax,
          isLoadMore: event.isLoadMore,
        ),
      );
    } on NetworkException catch (e) {
      emit(ProductError(message: e.message, isNetworkError: true));
    } on ServerException catch (e) {
      emit(ProductError(message: e.message));
    } catch (e) {
      emit(ProductError(message: 'Failed to fetch products'));
    }
  }

  Future<void> _onFilterProductsByCategory(
    FilterProductsByCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      // Get current categories from the previous state if available
      List<CategoryEntity> currentCategories = [];
      if (state is ProductDataLoaded) {
        currentCategories = (state as ProductDataLoaded).categories;
      }

      emit(ProductLoading(isLoadingProducts: true));

      _allProducts.clear();
      _currentSkip = 0;
      _currentCategorySlug = event.category.slug;

      final products = await getProductsUseCase(
        limit: _pageSize,
        skip: 0,
        category: event.category.slug,
      );

      _allProducts.addAll(products);
      _currentSkip = products.length;

      emit(
        ProductDataLoaded(
          products: List.from(_allProducts),
          categories: currentCategories,
          selectedCategory: event.category,
          hasReachedMax: products.length < _pageSize,
        ),
      );
    } on NetworkException catch (e) {
      emit(ProductError(message: e.message, isNetworkError: true));
    } on ServerException catch (e) {
      emit(ProductError(message: e.message));
    } catch (e) {
      emit(ProductError(message: 'Failed to filter products'));
    }
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());

      final products = await searchProductsUseCase(event.query);

      emit(ProductSearchLoaded(products: products, query: event.query));
    } on NetworkException catch (e) {
      emit(ProductError(message: e.message, isNetworkError: true));
    } on ServerException catch (e) {
      emit(ProductError(message: e.message));
    } catch (e) {
      emit(ProductError(message: 'Failed to search products'));
    }
  }

  Future<void> _onFetchProductById(
    FetchProductByIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());

      final product = await getProductByIdUseCase(event.id);

      emit(ProductDetailLoaded(product: product));
    } on NetworkException catch (e) {
      emit(ProductError(message: e.message, isNetworkError: true));
    } on ServerException catch (e) {
      emit(ProductError(message: e.message));
    } catch (e) {
      emit(ProductError(message: 'Failed to fetch product'));
    }
  }

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading(isLoadingCategories: true));

      final categories = await getCategoriesUseCase();

      // If we have products, keep them, otherwise just show categories
      if (state is ProductDataLoaded) {
        final currentState = state as ProductDataLoaded;
        emit(currentState.copyWith(categories: categories));
      } else {
        emit(
          ProductDataLoaded(
            products: const [],
            categories: categories,
            hasReachedMax: true,
          ),
        );
      }
    } on NetworkException catch (e) {
      emit(ProductError(message: e.message, isNetworkError: true));
    } on ServerException catch (e) {
      emit(ProductError(message: e.message));
    } catch (e) {
      emit(ProductError(message: 'Failed to fetch categories'));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<ProductState> emit) {
    if (_allProducts.isNotEmpty) {
      // Get current categories if we're in a loaded state
      List<CategoryEntity> currentCategories = [];
      CategoryEntity? selectedCategory;

      if (state is ProductDataLoaded) {
        final currentState = state as ProductDataLoaded;
        currentCategories = currentState.categories;
        selectedCategory = currentState.selectedCategory;
      }

      emit(
        ProductDataLoaded(
          products: List.from(_allProducts),
          categories: currentCategories,
          selectedCategory: selectedCategory,
          hasReachedMax: _allProducts.length >= _totalProducts,
        ),
      );
    } else {
      add(FetchInitialDataEvent());
    }
  }

  void _onClearFilter(ClearFilterEvent event, Emitter<ProductState> emit) {
    //fetch initial data again
    _currentCategorySlug = null;
    add(FetchInitialDataEvent());
  }

  // Helper method to load more products
  void loadMoreProducts() {
    add(
      FetchProductsEvent(
        limit: _pageSize,
        skip: _currentSkip,
        category: _currentCategorySlug,
        isLoadMore: true,
      ),
    );
  }
}
