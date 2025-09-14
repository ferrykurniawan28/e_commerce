import 'package:e_commerce/core/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/widgets/wishlist_product_card.dart';

class DismissibleWishlistItem extends StatelessWidget {
  final dynamic wishlistProduct;
  final String userId;

  const DismissibleWishlistItem({
    super.key,
    required this.wishlistProduct,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('wishlist_${wishlistProduct.product.id}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (direction) => _showRemoveConfirmDialog(context),
      onDismissed: (direction) => _onItemDismissed(context),
      child: WishlistProductCard(
        wishlistProduct: wishlistProduct,
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
            size: 24,
          ),
          spacerWidth(8),
          Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRemoveConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Wishlist'),
        content: Text(
          'Are you sure you want to remove "${wishlistProduct.product.title}" from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _onItemDismissed(BuildContext context) {
    // Remove from wishlist
    context.read<WishlistBloc>().add(
          RemoveFromWishlistEvent(
            productId: wishlistProduct.product.id,
            userId: userId,
          ),
        );

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed "${wishlistProduct.product.title}" from wishlist',
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            context.read<WishlistBloc>().add(
                  AddToWishlistEvent(
                    productId: wishlistProduct.product.id,
                    userId: userId,
                  ),
                );
          },
        ),
      ),
    );
  }
}
