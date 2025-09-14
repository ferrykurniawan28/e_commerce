import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';

class CartFloatingActionButton extends StatelessWidget {
  const CartFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;

        if (state is CartLoaded) {
          itemCount = state.totalItems;
        }

        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/cart');
          },
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              if (itemCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      itemCount > 99 ? '99+' : '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: Text('Cart${itemCount > 0 ? ' ($itemCount)' : ''}'),
        );
      },
    );
  }
}
