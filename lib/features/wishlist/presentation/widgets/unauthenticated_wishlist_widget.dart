import 'package:flutter/material.dart';
import 'package:e_commerce/core/helpers/helpers.dart';

class UnauthenticatedWishlistWidget extends StatelessWidget {
  const UnauthenticatedWishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login, size: 64, color: Colors.grey),
          spacerHeight(16),
          Text(
            'Please log in to view your wishlist',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
