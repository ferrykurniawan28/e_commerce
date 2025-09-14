import 'package:e_commerce/features/auth/presentation/pages/pages.dart';
import 'package:e_commerce/features/cart/presentation/presentation.dart';
import 'package:e_commerce/features/home/presentation/pages/pages.dart';
import 'package:e_commerce/features/profile/presentation/profile.dart';
import 'package:e_commerce/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../features/product/presentation/pages/pages.dart';

part 'auth.dart';

class AppRoutes extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const Splash());
    r.module('/auth', module: AuthModule());
    r.child(
      '/home',
      child: (_) => const HomePage(),
      children: [
        ChildRoute('/', child: (_) => const ProductList()),
        ChildRoute('/wishlist', child: (_) => const WishlistPage()),
        ChildRoute('/profile', child: (_) => const ProfilePage()),
        // ModuleRoute('/cart', module: CartModule()),
        // ModuleRoute('/profile', module: ProfileModule()),
      ],
    );
    r.child('/product/:id', child: (context) {
      final productId = int.parse(Modular.args.params['id']!);
      return ProductDetailPage(productId: productId);
    });
    r.child('/cart', child: (context) {
      return CartPage();
    });
  }
}
