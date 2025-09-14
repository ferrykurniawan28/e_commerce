part of 'pages.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Check Firebase auth status when splash screen loads
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Trigger auth status check event using BlocProvider.of to avoid conflicts
    BlocProvider.of<AuthBloc>(context).add(AuthStatusChecked());
  }

  void _navigateBasedOnAuthState(AuthState state) {
    if (state is AuthAuthenticated) {
      Modular.to.navigate('/home');
    } else if (state is AuthUnauthenticated) {
      Modular.to.navigate('/auth/login');
    }
    // If AuthLoading, we wait for the next state
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Add a small delay for better UX (show splash for at least 2 seconds)
        Future.delayed(const Duration(seconds: 2), () {
          _navigateBasedOnAuthState(state);
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 120,
                color: Colors.blue,
              ),
              spacerHeight(20),
              Text('Smart Shopping', style: titleTextStyle),
              spacerHeight(10),
              Text(
                'Your one-stop e-commerce solution',
                style: subtitleTextStyle,
              ),
              spacerHeight(40),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
