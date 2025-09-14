import 'package:e_commerce/core/helpers/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_commerce/features/product/presentation/pages/product_detail.dart';
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
  bool _isSearchFocused = false;
  String _selectedCategory = 'All';
  List<CategoryEntity> _categories = []; // Store categories separately
  List<ProductEntity> _products = []; // Store products separately

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    // Trigger initial data fetch
    context.read<ProductBloc>().add(FetchInitialDataEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we need to refresh data when coming back to this page
    final currentState = context.read<ProductBloc>().state;
    if (currentState is ProductDetailLoaded && _products.isEmpty) {
      // If we're coming back from detail page and have no products, refresh
      context.read<ProductBloc>().add(FetchInitialDataEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<ProductBloc>().add(SearchProductsEvent(query: query));
    } else {
      context.read<ProductBloc>().add(ClearSearchEvent());
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<ProductBloc>().add(ClearSearchEvent());
    setState(() {
      _selectedCategory = 'All'; // Reset to All when clearing search
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
            context.read<ProductBloc>().add(SearchProductsEvent(query: value));
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
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              // Navigate to cart page
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
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildProductsSection(state)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsSection(ProductState state) {
    // Update stored categories and products when new data is loaded
    if (state is ProductDataLoaded) {
      if (state.categories.isNotEmpty) {
        _categories = state.categories;
      }
      if (state.products.isNotEmpty) {
        _products = state.products;
      }
    }

    // Also update products for search results
    if (state is ProductSearchLoaded) {
      _products = state.products;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            state is ProductSearchLoaded ? 'Search Results' : 'Products',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Filter Categories - Show if categories are available
          if (_categories.isNotEmpty) ...[
            _buildCategoryFilter(_categories),
            const SizedBox(height: 20),
          ],

          // Products Grid
          if (state is ProductLoading && state.isLoadingProducts)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_products.isNotEmpty)
            _buildProductsGrid(_products)
          else if (state is ProductError)
            _buildErrorWidget(state.message)
          else if (state is ProductInitial ||
              (state is ProductDetailLoaded && _products.isEmpty))
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No products available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
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
                setState(() {
                  _selectedCategory = category.name;
                });

                if (category.name == 'All') {
                  // Clear any filters and fetch all products
                  context.read<ProductBloc>().add(ClearFilterEvent());
                } else {
                  context.read<ProductBloc>().add(
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
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProductBloc>().add(FetchInitialDataEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: product.id),
          ),
        );
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: product.thumbnail.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: BoxFit.cover,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // Container closing
    ); // GestureDetector closing
  }
}
