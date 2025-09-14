import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helpers/helpers.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shimmer/shimmer.dart';

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
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isSearchFocused ? Colors.blue : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search products, brands...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: _isSearchFocused ? Colors.blue : Colors.grey.shade500,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade500,
                    size: 18,
                  ),
                  onPressed: _clearSearch,
                )
              : Icon(Icons.mic, color: Colors.grey.shade500, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        style: const TextStyle(fontSize: 14),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            ReadContext(context)
                .read<ProductBloc>()
                .add(SearchProductsEvent(query: value));
            _searchFocusNode.unfocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchField(),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              int cartCount = 0;
              if (cartState is CartLoaded) {
                cartCount = cartState.items.fold<int>(
                  0,
                  (sum, item) => sum + item.quantity,
                );
              }

              return Stack(
                children: [
                  if (cartCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartCount > 99 ? '99+' : cartCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () => Modular.to.pushNamed('/cart'),
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          print('ProductList Listener - State: ${state.runtimeType}');
          if (state is ProductDataLoaded) {
            print(
                'Products loaded: ${state.products.length}, isLoadMore: ${state.isLoadMore}');
          }

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
          _buildCategoryFilter(_categories),
          spacerHeight(20),
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  spacerHeight(16),
                  Text(
                    'No products available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  spacerHeight(8),
                  Text(
                    'Check back later for new products',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryFilter(List<CategoryEntity> categories) {
    // Create a list with "All" as the first option
    final allCategories = [
      // Create a temporary "All" category
      CategoryEntity(name: 'All', slug: 'all', url: ''),
      ...categories,
    ];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected = _selectedCategory == category.name;

          return Padding(
            padding: EdgeInsets.only(
              right: index == allCategories.length - 1 ? 0 : 8.0,
            ),
            child: FilterChip(
              label: Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                print(
                    'Category selected: ${category.name}, slug: ${category.slug}');
                setState(() {
                  _selectedCategory = category.name;
                  _isLoadingMore = false;
                  _hasMoreData = true;
                  // Clear products to force refresh
                  _products.clear();
                });

                if (category.name == 'All') {
                  print('Clearing filter - fetching all products');
                  // Clear any filters and fetch all products
                  ReadContext(context)
                      .read<ProductBloc>()
                      .add(ClearFilterEvent());
                } else {
                  print(
                      'Filtering by category: ${category.name} (${category.slug})');
                  ReadContext(context).read<ProductBloc>().add(
                        FilterProductsByCategoryEvent(category: category),
                      );
                }
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No products found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

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
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            spacerHeight(20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            spacerHeight(8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            spacerHeight(24),
            ElevatedButton(
              onPressed: () {
                ReadContext(context)
                    .read<ProductBloc>()
                    .add(FetchInitialDataEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    final hasDiscount = product.discountPercentage > 0;
    final discountedPrice = hasDiscount
        ? product.price - (product.price * product.discountPercentage / 100)
        : product.price;

    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed('/product/${product.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: product.thumbnail.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.thumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),

                    // Discount badge
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price section
                        if (hasDiscount) ...[
                          Row(
                            children: [
                              Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              spacerWidth(4),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ] else ...[
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],

                        spacerHeight(4),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            spacerWidth(4),
                            Text(
                              product.rating?.toStringAsFixed(1) ?? '0.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        // Rating
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        return _buildShimmerCard();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
            ),
            // Shimmer Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title shimmer
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    spacerHeight(6),
                    // Price shimmer
                    Container(
                      height: 16,
                      width: 80,
                      color: Colors.white,
                    ),
                    spacerHeight(6),
                    // Rating shimmer
                    Container(
                      height: 12,
                      width: 60,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          spacerWidth(12),
          Text(
            'Loading more products...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
