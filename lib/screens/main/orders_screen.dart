import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../constants/app_constants.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    // TODO: Load orders from API
    setState(() {
      _orders = [
        // Sample data for demonstration
        OrderModel(
          id: '1',
          userId: 'user1',
          items: [
            OrderItemModel(
              productId: '1',
              productName: 'Qoramol yemi',
              productImage: '',
              price: 15000.0,
              quantity: 2,
              unit: 'kg',
            ),
          ],
          subtotal: 30000.0,
          deliveryFee: 50000.0,
          total: 80000.0,
          status: OrderStatus.delivered,
          paymentStatus: PaymentStatus.paid,
          paymentMethod: PaymentMethod.cash,
          deliveryAddress: AddressModel(
            id: '1',
            title: 'Uy',
            fullAddress: 'Toshkent shahar, Chilonzor tumani',
            latitude: 41.2995,
            longitude: 69.2401,
          ),
          orderDate: DateTime.now().subtract(const Duration(days: 2)),
          deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
          trackingNumber: 'TRK123456789',
        ),
        OrderModel(
          id: '2',
          userId: 'user1',
          items: [
            OrderItemModel(
              productId: '2',
              productName: 'Tovuq yemi',
              productImage: '',
              price: 12000.0,
              quantity: 1,
              unit: 'kg',
            ),
          ],
          subtotal: 12000.0,
          deliveryFee: 50000.0,
          total: 62000.0,
          status: OrderStatus.onDelivery,
          paymentStatus: PaymentStatus.paid,
          paymentMethod: PaymentMethod.card,
          deliveryAddress: AddressModel(
            id: '1',
            title: 'Uy',
            fullAddress: 'Toshkent shahar, Chilonzor tumani',
            latitude: 41.2995,
            longitude: 69.2401,
          ),
          orderDate: DateTime.now().subtract(const Duration(hours: 5)),
          trackingNumber: 'TRK987654321',
        ),
      ];
    });
  }

  List<OrderModel> get _filteredOrders {
    switch (_tabController.index) {
      case 0:
        return _orders;
      case 1:
        return _orders.where((order) => order.status == OrderStatus.pending || 
                                        order.status == OrderStatus.confirmed).toList();
      case 2:
        return _orders.where((order) => order.status == OrderStatus.preparing || 
                                        order.status == OrderStatus.ready ||
                                        order.status == OrderStatus.onDelivery).toList();
      case 3:
        return _orders.where((order) => order.status == OrderStatus.delivered).toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyurtmalarim'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Barchasi'),
            Tab(text: 'Kutilmoqda'),
            Tab(text: 'Jarayonda'),
            Tab(text: 'Yetkazilgan'),
          ],
        ),
      ),
      body: _orders.isEmpty
          ? _buildEmptyOrders()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(_orders),
                _buildOrdersList(_filteredOrders),
                _buildOrdersList(_filteredOrders),
                _buildOrdersList(_filteredOrders),
              ],
            ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Buyurtmalar yo\'q',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Birinchi buyurtmangizni berish uchun katalogga o\'ting',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen
              // TODO: Navigate to home screen
            },
            child: const Text('Katalogga o\'tish'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'Bu bo\'limda buyurtmalar yo\'q',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buyurtma #${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.orderDate.day}.${order.orderDate.month}.${order.orderDate.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(AppConstants.orderStatusColors[order.status.toString().split('.').last] ?? 0xFF000000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusText,
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
          
          // Order Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mahsulotlar:',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.productName} x${item.quantity}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '${item.total.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
                
                const Divider(),
                
                // Order Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Yetkazib berish:'),
                    Text('${order.deliveryFee.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jami:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${order.total.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                
                if (order.trackingNumber != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Kuzatish raqami: ${order.trackingNumber}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Order Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Show order details
                    },
                    child: const Text('Batafsil'),
                  ),
                ),
                const SizedBox(width: 12),
                if (order.status == OrderStatus.delivered)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Reorder
                      },
                      child: const Text('Qayta buyurtma'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
