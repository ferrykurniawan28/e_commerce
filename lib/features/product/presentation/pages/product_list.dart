// ignore_for_file: deprecated_member_use

import 'package:e_commerce/core/helpers/helpers.dart';
import 'package:e_commerce/core/widgets/widgets.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_commerce/features/product/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFocused = false;
  String _selectedCategory = 'All';
  List<CategoryEntity> _categories = [];
  List<ProductEntity> _products = [];
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);

    // Trigger initial data fetch
    ReadContext(context).read<ProductBloc>().add(FetchInitialDataEvent());

    // Load cart data to get cart count
    _loadCartData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we need to refresh data when coming back to this page
    final currentState = ReadContext(context).read<ProductBloc>().state;
    if (currentState is ProductDetailLoaded) {
      // If we're coming back from detail page, reset and refresh
      setState(() {
        _selectedCategory = 'All';
        _isLoadingMore = false;
        _hasMoreData = true;
      });
      ReadContext(context).read<ProductBloc>().add(FetchInitialDataEvent());
      // Also reload cart data when returning to this page
      _loadCartData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger pagination when user is 300 pixels from bottom (even smoother experience)
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll - 300; // Trigger 300px before bottom

    if (currentScroll >= threshold && maxScroll > 0) {
      // User is near the bottom
      if (!_isLoadingMore && _hasMoreData && _searchController.text.isEmpty) {
        // Only load more if not searching and not already loading
        _loadMoreProducts();
      }
    }
  }

  void _loadMoreProducts() {
    if (_products.isEmpty || _isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    final category = _selectedCategory == 'All' ? null : _selectedCategory;
    ReadContext(context).read<ProductBloc>().add(
          FetchProductsEvent(
            limit: 20,
            skip: _products.length,
            category: category,
            isLoadMore: true,
          ),
        );
  }

  void _loadCartData() {
    final authState = ReadContext(context).read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      ReadContext(context).read<CartBloc>().add(
            LoadCartEvent(userId: authState.user.id),
          );
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoadingMore = false;
      _hasMoreData = true;
      _products.clear();
    });

    // Refresh data based on current state
    if (_searchController.text.isNotEmpty) {
      ReadContext(context)
          .read<ProductBloc>()
          .add(SearchProductsEvent(query: _searchController.text));
    } else if (_selectedCategory != 'All') {
      // Find the category entity
      final category = _categories.firstWhere(
        (cat) => cat.name == _selectedCategory,
        orElse: () => CategoryEntity(name: 'All', slug: 'all', url: ''),
      );
      ReadContext(context).read<ProductBloc>().add(
            FilterProductsByCategoryEvent(category: category),
          );
    } else {
      ReadContext(context).read<ProductBloc>().add(FetchInitialDataEvent());
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isLoadingMore = false;
      _hasMoreData = true;
    });

    if (query.isNotEmpty) {
      ReadContext(context)
          .read<ProductBloc>()
          .add(SearchProductsEvent(query: query));
    } else {
      ReadContext(context).read<ProductBloc>().add(ClearSearchEvent());
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    ReadContext(context).read<ProductBloc>().add(ClearSearchEvent());
    setState(() {
      _selectedCategory = 'All'; // Reset to All when clearing search
      _isLoadingMore = false;
      _hasMoreData = true;
    });
  }

  Widget _buildSearchField() {
    return ProductSearchField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      onChanged: _onSearchChanged,
      onClear: _clearSearch,
      isSearchFocused: _isSearchFocused,
      onSubmitted: () {
        ReadContext(context)
            .read<ProductBloc>()
            .add(SearchProductsEvent(query: _searchController.text));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? null : theme.colorScheme.surface,
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1F2E),
                      Color(0xFF0A0E1A),
                    ],
                  )
                : null,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: isDark ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: _buildSearchField(),
            actions: [
              const CartIconWithBadge(),
            ],
            toolbarHeight: 70,
          ),
        ),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          // Handle load more completion
          if (state is ProductDataLoaded && state.isLoadMore) {
            setState(() {
              _isLoadingMore = false;
              // Check if we got less than requested items (end of data)
              _hasMoreData = !state.hasReachedMax;
              // The products in state already include all products, so just update
              _products = state.products;
            });
          } else if (state is ProductDataLoaded && !state.isLoadMore) {
            // Handle initial load or category change
            setState(() {
              _products = state.products;
              _hasMoreData = !state.hasReachedMax;
              _isLoadingMore = false;
              // Also update categories if available
              if (state.categories.isNotEmpty) {
                _categories = state.categories;
              }
            });
          } else if (state is ProductSearchLoaded) {
            // Handle search results
            setState(() {
              _products = state.products;
              _hasMoreData = false; // Search doesn't support pagination yet
              _isLoadingMore = false;
            });
          } else if (state is ProductError) {
            setState(() {
              _isLoadingMore = false;
            });
            if (_isLoadingMore) {
              // Show snackbar for pagination errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Failed to load more products: ${state.message}'),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () => _loadMoreProducts(),
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductsSection(state),
                  // Show loading indicator at bottom when loading more
                  if (_isLoadingMore) _buildLoadMoreIndicator(),
                  // Show "no more products" message when reached end
                  if (!_isLoadingMore && !_hasMoreData && _products.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          spacerWidth(8),
                          Text(
                            'All products loaded',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Add some bottom padding for better scrolling experience
                  if (!_isLoadingMore && _products.isNotEmpty) spacerHeight(20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsSection(ProductState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Categories - Show if categories are available
        if (_categories.isNotEmpty) ...[
          spacerHeight(10),
          _buildCategoryFilter(_categories),
          spacerHeight(10),
        ],

        // Products Grid
        if (state is ProductLoading && !state.isLoadMore)
          Column(
            children: [
              spacerHeight(10),
              _buildShimmerGrid(),
            ],
          )
        else if (_products.isNotEmpty)
          _buildProductsGrid(_products)
        else if (state is ProductError)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: _buildErrorWidget(state.message),
          )
        else if (state is ProductInitial ||
            (state is ProductDetailLoaded && _products.isEmpty))
          Column(
            children: [
              spacerHeight(10),
              _buildShimmerGrid(),
            ],
          )
        else
          const EmptyProductsWidget(),
      ],
    );
  }

  Widget _buildCategoryFilter(List<CategoryEntity> categories) {
    return CategoryFilter(
      categories: categories,
      selectedCategory: _selectedCategory,
      onCategorySelected: (category) {
        setState(() {
          _selectedCategory = category.name;
          _isLoadingMore = false;
          _hasMoreData = true;
          // Clear products to force refresh
          _products.clear();
        });

        if (category.name == 'All') {
          // Clear any filters and fetch all products
          ReadContext(context).read<ProductBloc>().add(ClearFilterEvent());
        } else {
          ReadContext(context).read<ProductBloc>().add(
                FilterProductsByCategoryEvent(category: category),
              );
        }
      },
    );
  }

  Widget _buildProductsGrid(List<ProductEntity> products) {
    return ProductsGrid(products: products);
  }

  Widget _buildErrorWidget(String message) {
    return ProductErrorWidget(
      message: message,
      onRetry: () {
        ReadContext(context).read<ProductBloc>().add(FetchInitialDataEvent());
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: 6, // Show 6 shimmer cards
      itemBuilder: (context, index) {
        return const ProductShimmerCard();
      },
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const LoadMoreIndicator();
  }
}
