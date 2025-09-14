import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/domain.dart';
import '../bloc/cart_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;

  const CartItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.thumbnail,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Price Information
                  Row(
                    children: [
                      if (item.discountPercentage > 0) ...[
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        '\$${item.discountedPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (item.discountPercentage > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.discountPercentage.toInt()}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quantity Controls and Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Row(
                        children: [
                          _buildQuantityButton(
                            context,
                            item.quantity == 1 ? Icons.delete : Icons.remove,
                            () => item.quantity == 1
                                ? _removeFromCart(context)
                                : _decrementQuantity(context),
                            true, // Always enabled since delete is always available
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          _buildQuantityButton(
                            context,
                            Icons.add,
                            () => _incrementQuantity(context),
                            true,
                          ),
                        ],
                      ),
                      // Total Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: enabled ? Colors.grey[400]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(6),
        color: enabled ? null : Colors.grey[100],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: enabled ? onPressed : null,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? Colors.grey[700] : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  void _incrementQuantity(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CartBloc>().add(
            UpdateCartItemQuantityEvent(
              userId: authState.user.id,
              productId: item.productId,
              quantity: item.quantity + 1,
            ),
          );
    }
  }

  void _decrementQuantity(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && item.quantity > 1) {
      context.read<CartBloc>().add(
            UpdateCartItemQuantityEvent(
              userId: authState.user.id,
              productId: item.productId,
              quantity: item.quantity - 1,
            ),
          );
    }
  }

  void _removeFromCart(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CartBloc>().add(
            RemoveFromCartEvent(
              userId: authState.user.id,
              productId: item.productId,
            ),
          );
    }
  }
}
