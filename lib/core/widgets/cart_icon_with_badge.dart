part of 'widgets.dart';

class CartIconWithBadge extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color badgeColor;
  final double iconSize;

  const CartIconWithBadge({
    super.key,
    this.onPressed,
    this.iconColor = Colors.black87,
    this.badgeColor = Colors.red,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        int cartCount = 0;
        if (cartState is CartLoaded) {
          cartCount = cartState.items.fold<int>(
            0,
            (sum, item) => sum + item.quantity,
          );
        }

        return Stack(
          children: [
            if (cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    cartCount > 99 ? '99+' : cartCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: iconColor,
                size: iconSize,
              ),
              onPressed: onPressed ?? () => Modular.to.pushNamed('/cart'),
            ),
          ],
        );
      },
    );
  }
}
