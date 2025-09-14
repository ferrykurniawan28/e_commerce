import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce/core/theme/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('profile_scaffold'),
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          // Only listen to auth state changes, not theme rebuilds
          return previous.runtimeType != current.runtimeType;
        },
        buildWhen: (previous, current) {
          // Only rebuild when auth state actually changes
          return previous.runtimeType != current.runtimeType;
        },
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            ReadContext(context)
                .read<WishlistBloc>()
                .add(const ResetWishlistEvent());
            ReadContext(context).read<CartBloc>().add(const ResetCartEvent());
            Modular.to.navigate('/auth/login');
          }
        },
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  spacerHeight(16),
                  Text(
                    'Please log in to view your profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final user = authState.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                spacerHeight(20),

                // Profile Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).brightness ==
                            Brightness.dark
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : Colors.blue.shade100,
                    backgroundImage:
                        user.photoUrl != null && user.photoUrl!.isNotEmpty
                            ? NetworkImage(user.photoUrl!)
                            : null,
                    child: user.photoUrl == null || user.photoUrl!.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.blue.shade600,
                          )
                        : null,
                  ),
                ),

                spacerHeight(20),

                // User Name
                Text(
                  user.displayName ?? 'User',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),

                spacerHeight(8),

                // Email
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),

                spacerHeight(40),

                // Profile Options
                _buildProfileOption(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {
                    // TODO: Navigate to edit profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit Profile - Coming Soon'),
                      ),
                    );
                  },
                ),

                _buildProfileOption(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Order History',
                  onTap: () {
                    // TODO: Navigate to order history
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order History - Coming Soon'),
                      ),
                    );
                  },
                ),

                _buildProfileOption(
                  icon: Icons.favorite_outline,
                  title: 'Wishlist',
                  onTap: () {
                    Modular.to.pushNamed('/home/wishlist');
                  },
                ),

                _buildProfileOption(
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  onTap: () {
                    // TODO: Navigate to addresses
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Addresses - Coming Soon'),
                      ),
                    );
                  },
                ),

                _buildProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    // TODO: Navigate to settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings - Coming Soon'),
                      ),
                    );
                  },
                ),

                // Theme Toggle Section
                Container(
                  key: const ValueKey('profile_theme_toggle_container'),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: const ThemeToggleWidget(
                    key: ValueKey('profile_theme_toggle_widget'),
                  ),
                ),

                spacerHeight(20),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('logout_button'),
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        inherit: true,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        spacerWidth(8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),

                spacerHeight(40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final theme = Theme.of(context);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isDark ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  theme.colorScheme.primary.withOpacity(0.2),
                                  theme.colorScheme.primary.withOpacity(0.1),
                                ]
                              : [
                                  Colors.blue.shade50,
                                  Colors.blue.shade100,
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? theme.colorScheme.primary.withOpacity(0.3)
                              : Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isDark
                            ? theme.colorScheme.primary
                            : Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                    spacerWidth(16),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    spacerWidth(8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: isDark
                            ? theme.colorScheme.onSurface.withOpacity(0.6)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
