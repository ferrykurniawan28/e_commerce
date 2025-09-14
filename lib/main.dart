import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/core/services/hive_service.dart';
import 'package:e_commerce/core/utils/utils.dart';
import 'package:e_commerce/core/theme/app_theme.dart';
import 'package:e_commerce/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:e_commerce/features/auth/data/repositories/auth_reporistory_impl.dart';
import 'package:e_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_commerce/features/auth/domain/usecases/usecases.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce/features/product/data/datasources/datasources.dart';
import 'package:e_commerce/features/product/data/repositories/repositories.dart';
import 'package:e_commerce/features/product/domain/repositories/repositories.dart';
import 'package:e_commerce/features/product/domain/usecases/usecases.dart';
import 'package:e_commerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_commerce/features/wishlist/data/repositories/repositories.dart';
import 'package:e_commerce/features/wishlist/domain/repositories/repositories.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/usecases.dart';
import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_commerce/features/cart/data/repositories/repositories.dart';
import 'package:e_commerce/features/cart/domain/repositories/repositories.dart';
import 'package:e_commerce/features/cart/domain/usecases/usecases.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();

  // Initialize adaptive theme
  final savedThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.system;

  // DEBUG: Clear all Hive data on startup for debugging
  // await HiveService.clearAllDataForDebug();

  runApp(ModularApp(
      module: AppRoutes(), child: MainApp(savedThemeMode: savedThemeMode)));
}

class MainApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MainApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(create: (context) => Dio()),
        RepositoryProvider<Connectivity>(create: (context) => Connectivity()),
        RepositoryProvider<NetworkInfo>(
          create: (context) => NetworkInfoImpl(
            connectivity: RepositoryProvider.of<Connectivity>(context),
          ),
        ),
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: RepositoryProvider.of<AuthRemoteDataSource>(
              context,
            ),
            networkInfo: RepositoryProvider.of<NetworkInfo>(context),
          ),
        ),
        RepositoryProvider<ProductRemoteDataSource>(
          create: (context) => ProductRemoteDataSourceImpl(
            dio: RepositoryProvider.of<Dio>(context),
          ),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            remoteDataSource: RepositoryProvider.of<ProductRemoteDataSource>(
              context,
            ),
            networkInfo: RepositoryProvider.of<NetworkInfo>(context),
          ),
        ),
        RepositoryProvider<CategoryRemoteDataSource>(
          create: (context) => CategoryRemoteDataSourceImpl(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(
            remoteDataSource: RepositoryProvider.of<CategoryRemoteDataSource>(
              context,
            ),
            networkInfo: RepositoryProvider.of<NetworkInfo>(context),
          ),
        ),
        RepositoryProvider<WishlistRepository>(
          create: (context) => WishlistRepositoryImpl(),
        ),
        RepositoryProvider<CartRepository>(
          create: (context) => CartRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              loginUseCase: LoginUseCase(
                repository: RepositoryProvider.of<AuthRepository>(context),
              ),
              registerUseCase: RegisterUseCase(
                repository: RepositoryProvider.of<AuthRepository>(context),
              ),
              logoutUseCase: LogoutUseCase(
                repository: RepositoryProvider.of<AuthRepository>(context),
              ),
              checkAuthStatusUseCase: CheckAuthStatusUseCase(
                repository: RepositoryProvider.of<AuthRepository>(context),
              ),
              forgotPasswordUseCase: ForgotPasswordUseCase(
                repository: RepositoryProvider.of<AuthRepository>(context),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              getProductsUseCase: GetProductsUseCase(
                repository: RepositoryProvider.of<ProductRepository>(context),
              ),
              getProductByIdUseCase: GetProductByIdUseCase(
                repository: RepositoryProvider.of<ProductRepository>(context),
              ),
              searchProductsUseCase: SearchProductsUseCase(
                repository: RepositoryProvider.of<ProductRepository>(context),
              ),
              getCategoriesUseCase: GetCategoriesUseCase(
                repository: RepositoryProvider.of<CategoryRepository>(context),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              addToWishlistUseCase: AddToWishlistUseCase(
                repository: RepositoryProvider.of<WishlistRepository>(context),
              ),
              removeFromWishlistUseCase: RemoveFromWishlistUseCase(
                repository: RepositoryProvider.of<WishlistRepository>(context),
              ),
              getUserWishlistUseCase: GetUserWishlistUseCase(
                repository: RepositoryProvider.of<WishlistRepository>(context),
              ),
              getWishlistWithProductsUseCase: GetWishlistWithProductsUseCase(
                wishlistRepository:
                    RepositoryProvider.of<WishlistRepository>(context),
                productRepository:
                    RepositoryProvider.of<ProductRepository>(context),
              ),
              isInWishlistUseCase: IsInWishlistUseCase(
                repository: RepositoryProvider.of<WishlistRepository>(context),
              ),
              toggleWishlistUseCase: ToggleWishlistUseCase(
                repository: RepositoryProvider.of<WishlistRepository>(context),
              ),
              clearUserWishlistUseCase: ClearUserWishlistUseCase(
                repository: RepositoryProvider.of<WishlistRepository>(context),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              addToCartUseCase: AddToCartUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
              removeFromCartUseCase: RemoveFromCartUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
              updateCartItemQuantityUseCase: UpdateCartItemQuantityUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
              getCartItemsUseCase: GetCartItemsUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
              clearCartUseCase: ClearCartUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
              getCartItemCountUseCase: GetCartItemCountUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
              checkItemInCartUseCase: CheckItemInCartUseCase(
                repository: RepositoryProvider.of<CartRepository>(context),
              ),
            ),
          ),
        ],
        child: NetworkListener(
          child: Builder(
            builder: (context) {
              return AdaptiveTheme(
                light: AppTheme.lightTheme,
                dark: AppTheme.darkTheme,
                initial: savedThemeMode ?? AdaptiveThemeMode.system,
                builder: (theme, darkTheme) => MaterialApp.router(
                  routerDelegate: Modular.routerDelegate,
                  routeInformationParser: Modular.routeInformationParser,
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  darkTheme: darkTheme,
                  // themeAnimationCurve: Curves.bounceOut,
                  // Disable built-in theme animations to avoid TextStyle
                  // interpolation issues when switching themes rapidly.
                  themeAnimationDuration: Duration.zero,
                  title: 'E-Commerce App',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
