import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            user.email[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.displayName ?? 'Utilisateur',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FutureBuilder<List>(
                  future: ref.read(orderActionsProvider.future).then(
                        (actions) => ref
                            .read(userOrdersProvider(user.id).future)
                            .then((orders) => orders),
                      ),
                  builder: (context, snapshot) {
                    final ordersCount = snapshot.data?.length ?? 0;
                    final totalSpent = snapshot.data?.fold<double>(
                          0,
                          (sum, order) => sum + order.totalAmount,
                        ) ??
                        0.0;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Statistiques',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatCard(
                                  icon: Icons.shopping_bag,
                                  label: 'Commandes',
                                  value: ordersCount.toString(),
                                ),
                                _StatCard(
                                  icon: Icons.euro,
                                  label: 'Total dépensé',
                                  value: '${totalSpent.toStringAsFixed(2)} €',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: const Text('Mes commandes'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/orders'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: const Text('Mon panier'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/cart'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.red[50],
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red[700]),
                    title: Text(
                      'Se déconnecter',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    onTap: () => _showLogoutDialog(context, ref),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    int selectedIndex = 0;

    if (currentPath == '/catalog') {
      selectedIndex = 0;
    } else if (currentPath == '/cart') {
      selectedIndex = 1;
    } else if (currentPath == '/orders') {
      selectedIndex = 2;
    } else if (currentPath == '/profile') {
      selectedIndex = 3;
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/catalog');
            break;
          case 1:
            context.go('/cart');
            break;
          case 2:
            context.go('/orders');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.store),
          label: 'Catalogue',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart),
          label: 'Panier',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long),
          label: 'Commandes',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).signOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
