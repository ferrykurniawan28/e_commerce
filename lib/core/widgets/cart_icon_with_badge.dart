part of 'widgets.dart';

class CartIconWithBadge extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? badgeColor;
  final double iconSize;

  const CartIconWithBadge({
    super.key,
    this.onPressed,
    this.iconColor,
    this.badgeColor,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use theme-aware colors when not explicitly provided
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;
    final effectiveBadgeColor = badgeColor ??
        (isDark ? const Color(0xFFFF6B6B) : const Color(0xFFDC2626));

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
                    color: effectiveBadgeColor,
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    cartCount > 99 ? '99+' : cartCount.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: effectiveIconColor,
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
