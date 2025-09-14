import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce/features/wishlist/presentation/widgets/widgets.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const UnauthenticatedWishlistWidget();
          }

          return BlocConsumer<WishlistBloc, WishlistState>(
            listener: (context, state) {
              if (state is WishlistError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return _buildWishlistContent(context, state, authState.user.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildWishlistContent(
      BuildContext context, WishlistState state, String userId) {
    if (state is WishlistInitial) {
      // Load wishlist when page opens
      context.read<WishlistBloc>().add(
            LoadWishlistEvent(userId: userId),
          );
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WishlistLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WishlistLoaded ||
        state is WishlistItemAdded ||
        state is WishlistItemRemoved) {
      final wishlistProducts = _getWishlistProducts(state);

      if (wishlistProducts.isEmpty) {
        return const EmptyWishlistWidget();
      }

      return WishlistContent(
        wishlistProducts: wishlistProducts,
        userId: userId,
      );
    }

    return const Center(child: Text('Something went wrong'));
  }

  List<dynamic> _getWishlistProducts(WishlistState state) {
    if (state is WishlistLoaded) return state.wishlistProducts;
    if (state is WishlistItemAdded) return state.wishlistProducts;
    if (state is WishlistItemRemoved) return state.wishlistProducts;
    return [];
  }
}
