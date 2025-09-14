import 'package:flutter/material.dart';

class CartSummaryWidget extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final int itemCount;

  const CartSummaryWidget({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items ($itemCount)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '$totalItems items',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Free',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: totalItems > 0 ? () => _onCheckout(context) : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Proceed to Checkout',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Free shipping on orders over \$50',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckout(BuildContext context) {
    // TODO: Implement checkout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
