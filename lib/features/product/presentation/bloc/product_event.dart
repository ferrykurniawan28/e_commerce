part of 'product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialDataEvent extends ProductEvent {
  const FetchInitialDataEvent();
}

class FetchProductsEvent extends ProductEvent {
  final int limit;
  final int skip;
  final String? category;
  final bool isLoadMore;

  const FetchProductsEvent({
    this.limit = 20,
    this.skip = 0,
    this.category,
    this.isLoadMore = false,
  });

  @override
  List<Object> get props => [limit, skip, category ?? '', isLoadMore];
}

class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class FetchProductByIdEvent extends ProductEvent {
  final int id;

  const FetchProductByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class FetchCategoriesEvent extends ProductEvent {}

class ClearSearchEvent extends ProductEvent {}

class FilterProductsByCategoryEvent extends ProductEvent {
  final CategoryEntity category;

  const FilterProductsByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class ClearFilterEvent extends ProductEvent {}
