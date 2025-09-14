import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/widgets/dismissible_wishlist_item.dart';

class WishlistContent extends StatelessWidget {
  final List<dynamic> wishlistProducts;
  final String userId;

  const WishlistContent({
    super.key,
    required this.wishlistProducts,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WishlistBloc>().add(
              LoadWishlistEvent(userId: userId),
            );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wishlistProducts.length,
        itemBuilder: (context, index) {
          final wishlistProduct = wishlistProducts[index];
          return DismissibleWishlistItem(
            wishlistProduct: wishlistProduct,
            userId: userId,
          );
        },
      ),
    );
  }
}
