import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/features/product/domain/entities/entities.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
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
    // Fetch product details
    context.read<ProductBloc>().add(
      FetchProductByIdEvent(id: widget.productId),
    );
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoaded) {
            return _buildProductDetail(state.product);
          } else if (state is ProductError) {
            return _buildErrorWidget(state.message);
          }

          return const SizedBox.shrink();
        },
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
    final allImages = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, color: Colors.black87),
          ),
          onPressed: () {
            // TODO: Add to favorites
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.black87),
          ),
          onPressed: () {
            // TODO: Share product
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Image carousel
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onImageChanged,
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: allImages[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),

            // Image indicators
            if (allImages.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: allImages.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == entry.key
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Discount badge
            if (product.discountPercentage > 0)
              Positioned(
                top: 100,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '-${product.discountPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title and rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildRatingWidget(product.rating),
            ],
          ),

          const SizedBox(height: 8),

          // Brand and category
          Row(
            children: [
              if (product.brand != null) ...[
                Text(
                  'Brand: ${product.brand}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 16),
              ],
              Text(
                'Category: ${product.category}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price section
          _buildPriceSection(product),

          const SizedBox(height: 24),

          // Stock and availability
          _buildStockSection(product),

          const SizedBox(height: 24),

          // Quantity selector
          _buildQuantitySelector(),

          const SizedBox(height: 24),

          // Add to cart button
          _buildAddToCartButton(product),

          const SizedBox(height: 32),

          // Product description
          _buildDescriptionSection(product),

          const SizedBox(height: 24),

          // Product details
          _buildProductDetails(product),

          const SizedBox(height: 24),

          // Reviews section
          if (product.reviews != null && product.reviews!.isNotEmpty)
            _buildReviewsSection(product.reviews!),

          const SizedBox(
            height: 100,
          ), // Bottom padding for floating action button
        ],
      ),
    );
  }

  Widget _buildRatingWidget(double? rating) {
    if (rating == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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
            color: Colors.black87,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
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
        const SizedBox(width: 8),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
    final inStock = product.stock > 0;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: inStock
            ? () {
                // TODO: Add to cart functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added $_quantity ${product.title} to cart'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: inStock ? Colors.blue : Colors.grey,
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
      ),
    );
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
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(ProductEntity product) {
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

    final validDetails = details.entries
        .where((entry) => entry.value != null)
        .toList();

    if (validDetails.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
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
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
        const SizedBox(height: 12),
        ...reviews.take(3).map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(ReviewEntity review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review.reviewerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    review.rating.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment ?? 'No comment provided',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.date.toString().split(' ')[0], // Show only date part
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
