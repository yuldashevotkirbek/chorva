import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../constants/app_constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    // TODO: Load cart items from local storage or provider
    setState(() {
      _cartItems = [
        // Sample data for demonstration
        CartItemModel(
          productId: '1',
          productName: 'Qoramol yemi',
          productImage: '',
          price: 15000.0,
          quantity: 2,
          unit: 'kg',
          weight: 1.0,
        ),
        CartItemModel(
          productId: '2',
          productName: 'Tovuq yemi',
          productImage: '',
          price: 12000.0,
          quantity: 1,
          unit: 'kg',
          weight: 1.0,
        ),
      ];
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
    } else {
      setState(() {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  double get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + item.total);
  }

  double get _deliveryFee {
    return _subtotal >= AppConstants.freeDeliveryThreshold 
        ? 0 
        : AppConstants.defaultDeliveryFee;
  }

  double get _total {
    return _subtotal + _deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savatcha'),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Savatchani tozalash'),
                    content: const Text('Barcha mahsulotlarni savatchadan olib tashlashni xohlaysizmi?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Bekor qilish'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _cartItems.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Tozalash', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItem(item, index);
                    },
                  ),
                ),
                _buildCheckoutSection(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Savatcha bo\'sh',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Mahsulot qo\'shish uchun katalogga o\'ting',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
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

  Widget _buildCartItem(CartItemModel item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.productImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, color: Colors.grey);
                      },
                    ),
                  )
                : const Icon(Icons.image, color: Colors.grey),
          ),
          
          const SizedBox(width: 16),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(0)} ${AppConstants.currencySymbol} / ${item.unit}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.total.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _updateQuantity(index, item.quantity - 1),
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.green,
                        ),
                        Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _updateQuantity(index, item.quantity + 1),
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Remove Button
          IconButton(
            onPressed: () => _removeItem(index),
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mahsulotlar:'),
              Text('${_subtotal.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Yetkazib berish:'),
              Text(
                _deliveryFee == 0 
                    ? 'Bepul' 
                    : '${_deliveryFee.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jami:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_total.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to checkout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Buyurtma berish funksiyasi tez orada qo\'shiladi'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Buyurtma berish',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
