import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/admin_auth_service.dart';
import '../../models/admin_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  int _totalUsers = 0;
  int _totalProducts = 0;
  int _totalOrders = 0;
  double _totalRevenue = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Users count
      final usersSnapshot = await _firestore.collection('users').get();
      final usersCount = usersSnapshot.docs.length;

      // Products count
      final productsSnapshot = await _firestore.collection('products').get();
      final productsCount = productsSnapshot.docs.length;

      // Orders count and revenue
      final ordersSnapshot = await _firestore.collection('orders').get();
      final ordersCount = ordersSnapshot.docs.length;
      double revenue = 0.0;
      
      for (var doc in ordersSnapshot.docs) {
        final data = doc.data();
        if (data['totalAmount'] != null) {
          revenue += (data['totalAmount'] as num).toDouble();
        }
      }

      setState(() {
        _totalUsers = usersCount;
        _totalProducts = productsCount;
        _totalOrders = ordersCount;
        _totalRevenue = revenue;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ma\'lumotlarni yuklashda xatolik: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminAuthService = Provider.of<AdminAuthService>(context, listen: false);
    final admin = adminAuthService.currentAdmin;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text(admin?.name ?? 'Admin'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Chiqish', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade800],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xush kelibsiz, ${admin?.name ?? 'Admin'}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chorva Yem Admin Panel',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              admin?.role == 'super_admin' ? 'Super Admin' : 'Manager',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Statistics Cards
                    Text(
                      'Umumiy Statistika',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          'Foydalanuvchilar',
                          _totalUsers.toString(),
                          Icons.people,
                          Colors.green,
                        ),
                        _buildStatCard(
                          'Mahsulotlar',
                          _totalProducts.toString(),
                          Icons.inventory,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Buyurtmalar',
                          _totalOrders.toString(),
                          Icons.shopping_cart,
                          Colors.purple,
                        ),
                        _buildStatCard(
                          'Daromad',
                          '${_totalRevenue.toStringAsFixed(0)} so\'m',
                          Icons.attach_money,
                          Colors.blue,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'Tezkor Amallar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        if (admin?.canManageProducts ?? false)
                          _buildActionCard(
                            'Mahsulotlar',
                            Icons.inventory_2,
                            Colors.orange,
                            () => _navigateToProducts(),
                          ),
                        if (admin?.canManageOrders ?? false)
                          _buildActionCard(
                            'Buyurtmalar',
                            Icons.shopping_cart,
                            Colors.purple,
                            () => _navigateToOrders(),
                          ),
                        if (admin?.canManageUsers ?? false)
                          _buildActionCard(
                            'Foydalanuvchilar',
                            Icons.people,
                            Colors.green,
                            () => _navigateToUsers(),
                          ),
                        if (admin?.canViewAnalytics ?? false)
                          _buildActionCard(
                            'Analitika',
                            Icons.analytics,
                            Colors.blue,
                            () => _navigateToAnalytics(),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Recent Orders
                    Text(
                      'So\'nggi Buyurtmalar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('orders')
                          .orderBy('createdAt', descending: true)
                          .limit(5)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Text('Xatolik: ${snapshot.error}');
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(
                              child: Text(
                                'Hozircha buyurtmalar yo\'q',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Buyurtma #${doc.id.substring(0, 8)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${data['totalAmount'] ?? 0} so\'m',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(data['status'] ?? 'pending'),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getStatusText(data['status'] ?? 'pending'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Tugallangan';
      case 'processing':
        return 'Jarayonda';
      case 'cancelled':
        return 'Bekor qilingan';
      default:
        return 'Kutilmoqda';
    }
  }

  void _navigateToProducts() {
    // TODO: Navigate to products screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mahsulotlar sahifasi tez orada qo\'shiladi')),
    );
  }

  void _navigateToOrders() {
    // TODO: Navigate to orders screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buyurtmalar sahifasi tez orada qo\'shiladi')),
    );
  }

  void _navigateToUsers() {
    // TODO: Navigate to users screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foydalanuvchilar sahifasi tez orada qo\'shiladi')),
    );
  }

  void _navigateToAnalytics() {
    // TODO: Navigate to analytics screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analitika sahifasi tez orada qo\'shiladi')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chiqish'),
        content: const Text('Admin panelidan chiqishni xohlaysizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final adminAuthService = Provider.of<AdminAuthService>(context, listen: false);
              await adminAuthService.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/admin-login');
              }
            },
            child: const Text('Chiqish', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
