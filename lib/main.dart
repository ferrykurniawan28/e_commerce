import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/core/utils/utils.dart';
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
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ModularApp(module: AppRoutes(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
        ],
        child: NetworkListener(
          child: MaterialApp.router(
            routerDelegate: Modular.routerDelegate,
            routeInformationParser: Modular.routeInformationParser,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
