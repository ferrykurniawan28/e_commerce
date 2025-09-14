import 'package:e_commerce/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
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
                const SizedBox(height: 20),

                // Profile Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage:
                      user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? NetworkImage(user.photoUrl!)
                          : null,
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade600,
                        )
                      : null,
                ),

                const SizedBox(height: 20),

                // User Name
                Text(
                  user.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Email
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 40),

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

                const SizedBox(height: 20),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade600,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
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
