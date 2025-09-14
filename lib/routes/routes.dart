import 'package:e_commerce/features/auth/presentation/pages/pages.dart';
import 'package:e_commerce/features/home/presentation/pages/pages.dart';
import 'package:e_commerce/features/product/presentation/pages/product_list.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
        // ModuleRoute('/cart', module: CartModule()),
        // ModuleRoute('/profile', module: ProfileModule()),
      ],
    );
    // r.module('/home', module: HomeModule());
  }
}
