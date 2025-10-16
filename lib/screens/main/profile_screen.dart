import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isLoggedIn) {
            return _buildNotLoggedIn(context);
          }

          final user = authProvider.user!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                _buildMenuItems(context, authProvider),
                const SizedBox(height: 24),
                _buildLogoutButton(context, authProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Hisobingizga kiring',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Buyurtmalaringizni ko\'rish va boshqarish uchun',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Kirish'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: user.profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      user.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.green,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.green,
                  ),
          ),
          
          const SizedBox(height: 16),
          
          // User Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // User Email
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // User Phone
          Text(
            user.phone,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Edit Profile Button
          OutlinedButton(
            onPressed: () {
              // TODO: Navigate to edit profile
            },
            child: const Text('Profilni tahrirlash'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, AuthProvider authProvider) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Shaxsiy ma\'lumotlar',
        'subtitle': 'Profil ma\'lumotlarini yangilash',
        'onTap': () {
          // TODO: Navigate to personal info
        },
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Manzillar',
        'subtitle': 'Yetkazib berish manzillarini boshqarish',
        'onTap': () {
          // TODO: Navigate to addresses
        },
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'To\'lov usullari',
        'subtitle': 'Karta va to\'lov ma\'lumotlari',
        'onTap': () {
          // TODO: Navigate to payment methods
        },
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Bildirishnomalar',
        'subtitle': 'Bildirishnoma sozlamalari',
        'onTap': () {
          // TODO: Navigate to notifications
        },
      },
      {
        'icon': Icons.help_outline,
        'title': 'Yordam va qo\'llab-quvvatlash',
        'subtitle': 'Savollar va muammolar',
        'onTap': () {
          // TODO: Navigate to help
        },
      },
      {
        'icon': Icons.info_outline,
        'title': 'Ilova haqida',
        'subtitle': 'Versiya va ma\'lumotlar',
        'onTap': () {
          _showAboutDialog(context);
        },
      },
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(
        icon: item['icon'] as IconData,
        title: item['title'] as String,
        subtitle: item['subtitle'] as String,
        onTap: item['onTap'] as VoidCallback,
      )).toList(),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.green,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.logout,
            color: Colors.red,
            size: 20,
          ),
        ),
        title: const Text(
          'Chiqish',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Chiqish'),
              content: const Text('Hisobingizdan chiqishni xohlaysizmi?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Bekor qilish'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Chiqish', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.pets,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: [
        const Text('Chorva mollari uchun sifatli yem sotib olish va yetkazib berish xizmati.'),
      ],
    );
  }
}
