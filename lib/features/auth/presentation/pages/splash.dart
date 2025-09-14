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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Add a small delay for better UX (show splash for at least 2 seconds)
        Future.delayed(const Duration(seconds: 2), () {
          _navigateBasedOnAuthState(state);
        });
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Container(
          decoration: isDark
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.surface,
                      theme.colorScheme.surfaceContainer,
                    ],
                  ),
                )
              : BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.surface,
                      theme.colorScheme.primary.withOpacity(0.05),
                    ],
                  ),
                ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    boxShadow: isDark
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                spacerHeight(30),
                Text(
                  'Smart Shopping',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                spacerHeight(12),
                Text(
                  'Your one-stop e-commerce solution',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                spacerHeight(50),
                // Loading indicator with enhanced styling
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isDark
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
