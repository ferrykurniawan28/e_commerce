part of 'routes.dart';

class AuthModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/login', child: (_) => const LoginPage());
    r.child('/register', child: (_) => const RegisterPage());
  }
}
