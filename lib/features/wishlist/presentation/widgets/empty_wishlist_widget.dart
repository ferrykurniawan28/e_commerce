import 'package:flutter/material.dart';
import 'package:e_commerce/core/helpers/helpers.dart';

class EmptyWishlistWidget extends StatelessWidget {
  const EmptyWishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey,
          ),
          spacerHeight(16),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          spacerHeight(8),
          const Text(
            'Add products you love to your wishlist',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          spacerHeight(24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
