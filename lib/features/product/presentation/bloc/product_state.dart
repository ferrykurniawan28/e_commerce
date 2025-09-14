part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final bool isLoadingCategories;
  final bool isLoadingProducts;
  final bool isLoadMore;

  const ProductLoading({
    this.isLoadingCategories = false,
    this.isLoadingProducts = false,
    this.isLoadMore = false,
  });

  @override
  List<Object> get props => [
    isLoadingCategories,
    isLoadingProducts,
    isLoadMore,
  ];
}

class ProductDataLoaded extends ProductState {
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final bool hasReachedMax;
  final CategoryEntity? selectedCategory;
  final bool isSearching;

  const ProductDataLoaded({
    required this.products,
    required this.categories,
    this.hasReachedMax = false,
    this.selectedCategory,
    this.isSearching = false,
  });

  ProductDataLoaded copyWith({
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    bool? hasReachedMax,
    CategoryEntity? selectedCategory,
    bool? isSearching,
  }) {
    return ProductDataLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [
    products,
    categories,
    hasReachedMax,
    selectedCategory?.slug ?? '',
    isSearching,
  ];
}

class ProductSearchLoaded extends ProductState {
  final List<ProductEntity> products;
  final String query;

  const ProductSearchLoaded({required this.products, required this.query});

  @override
  List<Object> get props => [products, query];
}

class ProductDetailLoaded extends ProductState {
  final ProductEntity product;

  const ProductDetailLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductError extends ProductState {
  final String message;
  final bool isNetworkError;

  const ProductError({required this.message, this.isNetworkError = false});

  @override
  List<Object> get props => [message, isNetworkError];
}
