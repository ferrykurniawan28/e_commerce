import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/domain/entities/entities.dart';
import '../bloc/cart_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class AddToCartButton extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback? onAdded;

  const AddToCartButton({
    super.key,
    required this.product,
    this.onAdded,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartItemAdded && _isAdding) {
          setState(() => _isAdding = false);
          _animationController.reverse();
          widget.onAdded?.call();
        } else if (state is CartError && _isAdding) {
          setState(() => _isAdding = false);
          _animationController.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: _isAdding ? null : _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isAdding ? Colors.grey[400] : Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            icon: _isAdding
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.shopping_cart, size: 18),
            label: Text(
              _isAdding ? 'Adding...' : 'Add to Cart',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    setState(() => _isAdding = true);
    _animationController.forward();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<CartBloc>().add(
            AddToCartEvent(
              userId: authState.user.id,
              productId: widget.product.id,
              title: widget.product.title,
              thumbnail: widget.product.thumbnail,
              price: widget.product.price,
              discountPercentage: widget.product.discountPercentage,
            ),
          );
    } else {
      // Handle unauthenticated state
      setState(() => _isAdding = false);
      _animationController.reverse();
    }
  }
}
