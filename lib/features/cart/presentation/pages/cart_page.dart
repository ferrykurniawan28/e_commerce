import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../widgets/empty_cart_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CartBloc>().add(LoadCartEvent(userId: authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cart'),
              centerTitle: true,
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Please log in to view your cart',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        final userId = authState.user.id;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            centerTitle: true,
          ),
          body: BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartItemAdded ||
                  state is CartItemRemoved ||
                  state is CartItemUpdated ||
                  state is CartCleared) {
                final message = switch (state) {
                  CartItemAdded(message: final msg) => msg,
                  CartItemRemoved(message: final msg) => msg,
                  CartItemUpdated(message: final msg) => msg,
                  CartCleared(message: final msg) => msg,
                  _ => '',
                };

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is CartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return switch (state) {
                  CartInitial() => const Center(
                      child: Text('Initialize cart'),
                    ),
                  CartLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  CartLoaded() => _buildCartContent(state, userId),
                  CartError() => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading cart',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    LoadCartEvent(userId: userId),
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  _ => const Center(
                      child: Text('Unknown state'),
                    ),
                };
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartContent(CartLoaded state, String userId) {
    if (state.items.isEmpty) {
      return const EmptyCartWidget();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemWidget(
                item: item,
              );
            },
          ),
        ),
        CartSummaryWidget(
          totalItems: state.totalItems,
          totalPrice: state.totalPrice,
          itemCount: state.itemCount,
        ),
      ],
    );
  }
}
