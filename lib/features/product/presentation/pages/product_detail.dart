import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<ProductBloc>().add(
          FetchProductByIdEvent(id: widget.productId),
        );

    // Load wishlist and cart to check product status
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<WishlistBloc>().add(
            LoadWishlistEvent(userId: authState.user.id),
          );
      context.read<CartBloc>().add(
            LoadCartEvent(userId: authState.user.id),
          );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onImageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (state is ProductDetailLoaded) {
            return _buildProductDetail(state.product);
          } else if (state is ProductError) {
            return _buildErrorWidget(state.message);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductDetailLoaded) {
                return _buildAddToCartButton(state.product);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetail(ProductEntity product) {
    return CustomScrollView(
      slivers: [
        // App Bar with image carousel
        _buildSliverAppBar(product),

        // Product details content
        SliverToBoxAdapter(child: _buildProductContent(product)),
      ],
    );
  }

  Widget _buildSliverAppBar(ProductEntity product) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allImages =
        product.images.isNotEmpty ? product.images : [product.thumbnail];

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface.withOpacity(0.9)
                : Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            border: isDark
                ? Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black.withOpacity(0.1),
                blurRadius: isDark ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
            size: 22,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface.withOpacity(0.9)
                  : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: isDark
                  ? Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 1,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isDark ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.share,
              color: theme.colorScheme.onSurface,
              size: 22,
            ),
          ),
          onPressed: () {
            // TODO: Share product
          },
        ),
        spacerWidth(8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Image carousel with enhanced loading and error states
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onImageChanged,
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: allImages[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest
                        : Colors.grey.shade100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest
                        : Colors.grey.shade200,
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),

            // Enhanced image indicators with glow effect for dark mode
            if (allImages.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: allImages.asMap().entries.map((entry) {
                    final isActive = _currentImageIndex == entry.key;
                    return Container(
                      width: isActive ? 12 : 8,
                      height: isActive ? 12 : 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? (isDark
                                ? theme.colorScheme.primary
                                : Colors.white)
                            : (isDark
                                ? Colors.white.withOpacity(0.4)
                                : Colors.white.withOpacity(0.5)),
                        boxShadow: isDark && isActive
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Enhanced discount badge with better dark mode styling
            if (product.discountPercentage > 0)
              Positioned(
                top: 100,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isDark ? null : Colors.red,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(isDark ? 0.4 : 0.3),
                        blurRadius: isDark ? 8 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '-${product.discountPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductContent(ProductEntity product) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle for visual feedback
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Product title and rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                ),
                spacerWidth(12),
                _buildRatingWidget(product.rating),
              ],
            ),

            spacerHeight(12),

            // Brand and category with enhanced styling
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                if (product.brand != null)
                  _buildInfoChip(
                    icon: Icons.business,
                    label: 'Brand: ${product.brand}',
                    theme: theme,
                  ),
                _buildInfoChip(
                  icon: Icons.category,
                  label: 'Category: ${product.category}',
                  theme: theme,
                ),
              ],
            ),

            spacerHeight(20),

            // Price section
            _buildPriceSection(product),

            spacerHeight(24),

            // Stock and availability
            _buildStockSection(product),

            spacerHeight(24),

            // Quantity selector
            _buildQuantitySelector(),

            spacerHeight(32),

            // Product description
            _buildDescriptionSection(product),

            spacerHeight(24),

            // Product details
            _buildProductDetails(product),

            spacerHeight(24),

            // Reviews section
            if (product.reviews != null && product.reviews!.isNotEmpty)
              _buildReviewsSection(product.reviews!),

            spacerHeight(100),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceVariant.withOpacity(0.6)
            : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: isDark
            ? Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          spacerWidth(6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingWidget(double? rating) {
    if (rating == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  Colors.amber.withOpacity(0.2),
                  Colors.orange.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isDark ? null : Colors.amber.shade100,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(
                color: Colors.amber.withOpacity(0.3),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(isDark ? 0.2 : 0.1),
            blurRadius: isDark ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 18,
            color: isDark ? Colors.amber.shade300 : Colors.amber.shade700,
          ),
          spacerWidth(6),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.amber.shade200 : Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(ProductEntity product) {
    final hasDiscount = product.discountPercentage > 0;
    final discountedPrice =
        product.price - (product.price * product.discountPercentage / 100);

    return Row(
      children: [
        Text(
          '\$${hasDiscount ? discountedPrice.toStringAsFixed(2) : product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasDiscount) ...[
          spacerWidth(8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          spacerWidth(8),
          Text(
            'Save \$${(product.price - discountedPrice).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStockSection(ProductEntity product) {
    final inStock = product.stock > 0;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: inStock ? Colors.green : Colors.red,
          ),
        ),
        spacerWidth(8),
        Text(
          inStock ? 'In Stock (${product.stock} available)' : 'Out of Stock',
          style: TextStyle(
            fontSize: 16,
            color: inStock ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        spacerHeight(8),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _decrementQuantity,
                    icon: const Icon(Icons.remove),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _quantity.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _incrementQuantity,
                    icon: const Icon(Icons.add),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(ProductEntity product) {
    final theme = Theme.of(context);
    final inStock = product.stock > 0;

    return Row(
      children: [
        // Wishlist button
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! AuthAuthenticated) {
              return const SizedBox.shrink();
            }

            return BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, wishlistState) {
                bool isInWishlist = false;
                bool isLoading = wishlistState is WishlistLoading;

                // Check wishlist status from different state types
                if (wishlistState is WishlistLoaded ||
                    wishlistState is WishlistItemAdded ||
                    wishlistState is WishlistItemRemoved) {
                  final statusMap = switch (wishlistState) {
                    WishlistLoaded state => state.wishlistStatus,
                    WishlistItemAdded state => state.wishlistStatus,
                    WishlistItemRemoved state => state.wishlistStatus,
                    _ => <int, bool>{},
                  };
                  isInWishlist = statusMap[product.id] ?? false;
                }

                return Container(
                  width: 60,
                  height: 56,
                  margin: const EdgeInsets.only(right: 12),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<WishlistBloc>().add(
                                  ToggleWishlistEvent(
                                    userId: authState.user.id,
                                    productId: product.id,
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInWishlist
                          ? Colors.red
                          : (isLoading
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface),
                      foregroundColor: isInWishlist
                          ? Colors.white
                          : (isLoading
                              ? theme.colorScheme.onSurface.withAlpha(100)
                              : theme.colorScheme.onSurface),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )
                        : Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 24,
                          ),
                  ),
                );
              },
            );
          },
        ),

        // Add to cart button or quantity controls
        Expanded(
          child: SizedBox(
            height: 56,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is! AuthAuthenticated) {
                  return _buildSimpleAddToCartButton(product, inStock);
                }

                return BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    int currentQuantity = 0;

                    // Check if product is in cart
                    if (cartState is CartLoaded) {
                      final cartItems = cartState.items.where(
                        (item) => item.productId == product.id,
                      );
                      if (cartItems.isNotEmpty) {
                        currentQuantity = cartItems.first.quantity;
                      }
                    }

                    return BlocListener<CartBloc, CartState>(
                      listener: (context, state) {
                        if (state is CartError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        } else if (state is CartItemAdded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item added to cart')),
                          );
                        } else if (state is CartItemRemoved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Item removed from cart')),
                          );
                        }
                      },
                      child: currentQuantity > 0
                          ? _buildQuantityControls(
                              product, currentQuantity, authState.user.id)
                          : _buildAddToCartButtonWithAuth(
                              product, inStock, authState.user.id),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleAddToCartButton(ProductEntity product, bool inStock) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: inStock
          ? () {
              // Show login prompt or handle unauthenticated user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please login to add items to cart')),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            inStock ? theme.colorScheme.primary : theme.colorScheme.outline,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        inStock ? 'Add to Cart' : 'Out of Stock',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAddToCartButtonWithAuth(
      ProductEntity product, bool inStock, String userId) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: inStock
          ? () {
              context.read<CartBloc>().add(
                    AddToCartEvent(
                      userId: userId,
                      productId: product.id,
                      title: product.title,
                      thumbnail: product.thumbnail,
                      price: product.price,
                      discountPercentage: product.discountPercentage,
                      quantity: _quantity,
                    ),
                  );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            inStock ? theme.colorScheme.primary : theme.colorScheme.outline,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        inStock ? 'Add to Cart' : 'Out of Stock',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildQuantityControls(
      ProductEntity product, int currentQuantity, String userId) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildQuantityButton(
            context,
            currentQuantity == 1 ? Icons.delete : Icons.remove,
            () => _decrementCartQuantity(product, currentQuantity, userId),
            true,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                currentQuantity.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          _buildQuantityButton(
            context,
            Icons.add,
            () => _incrementCartQuantity(product, currentQuantity, userId),
            currentQuantity < product.stock,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    bool enabled,
  ) {
    return Container(
      width: 48,
      height: 52,
      decoration: BoxDecoration(
        color: enabled ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: enabled ? onPressed : null,
          child: Icon(
            icon,
            size: 20,
            color: enabled ? Colors.blue : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  void _incrementCartQuantity(
      ProductEntity product, int currentQuantity, String userId) {
    if (currentQuantity < product.stock) {
      context.read<CartBloc>().add(
            UpdateCartItemQuantityEvent(
              userId: userId,
              productId: product.id,
              quantity: currentQuantity + 1,
            ),
          );
    }
  }

  void _decrementCartQuantity(
      ProductEntity product, int currentQuantity, String userId) {
    if (currentQuantity > 1) {
      context.read<CartBloc>().add(
            UpdateCartItemQuantityEvent(
              userId: userId,
              productId: product.id,
              quantity: currentQuantity - 1,
            ),
          );
    } else {
      // Remove from cart when quantity is 1
      context.read<CartBloc>().add(
            RemoveFromCartEvent(
              userId: userId,
              productId: product.id,
            ),
          );
    }
  }

  Widget _buildDescriptionSection(ProductEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        spacerHeight(12),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(ProductEntity product) {
    final theme = Theme.of(context);

    final details = <String, String?>{
      'SKU': product.sku,
      'Weight': product.weight != null ? '${product.weight}g' : null,
      'Dimensions': product.dimensions != null
          ? '${product.dimensions!.width} × ${product.dimensions!.height} × ${product.dimensions!.depth} cm'
          : null,
      'Warranty': product.warrantyInformation,
      'Shipping': product.shippingInformation,
      'Return Policy': product.returnPolicy,
      'Minimum Order': product.minimumOrderQuantity != null
          ? '${product.minimumOrderQuantity} units'
          : null,
    };

    final validDetails =
        details.entries.where((entry) => entry.value != null).toList();

    if (validDetails.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        spacerHeight(12),
        ...validDetails.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${entry.key}:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value!,
                    style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withAlpha(200)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(List<ReviewEntity> reviews) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all reviews
              },
              child: const Text('View All'),
            ),
          ],
        ),
        spacerHeight(12),
        ...reviews.take(3).map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(ReviewEntity review) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? theme.colorScheme.outline : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review.reviewerName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  spacerWidth(4),
                  Text(
                    review.rating.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          spacerHeight(8),
          Text(
            review.comment ?? 'No comment provided',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withAlpha(180),
              height: 1.4,
            ),
          ),
          spacerHeight(8),
          Text(
            review.date.toString().split(' ')[0], // Show only date part
            style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withAlpha(150)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            spacerHeight(16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
            spacerHeight(16),
            ElevatedButton(
              onPressed: () {
                context.read<ProductBloc>().add(
                      FetchProductByIdEvent(id: widget.productId),
                    );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
