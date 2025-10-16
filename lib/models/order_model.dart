import 'product_model.dart';
import 'user_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  onDelivery,
  delivered,
  cancelled,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

enum PaymentMethod {
  cash,
  card,
  bankTransfer,
  digitalWallet,
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final AddressModel deliveryAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.orderDate,
    this.deliveryDate,
    this.notes,
    this.trackingNumber,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['paymentMethod']}',
        orElse: () => PaymentMethod.cash,
      ),
      deliveryAddress: AddressModel.fromJson(json['deliveryAddress']),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null 
          ? DateTime.parse(json['deliveryDate']) 
          : null,
      notes: json['notes'],
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'deliveryAddress': deliveryAddress.toJson(),
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'notes': notes,
      'trackingNumber': trackingNumber,
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Kutilmoqda';
      case OrderStatus.confirmed:
        return 'Tasdiqlangan';
      case OrderStatus.preparing:
        return 'Tayyorlanmoqda';
      case OrderStatus.ready:
        return 'Tayyor';
      case OrderStatus.onDelivery:
        return 'Yetkazilmoqda';
      case OrderStatus.delivered:
        return 'Yetkazilgan';
      case OrderStatus.cancelled:
        return 'Bekor qilingan';
    }
  }

  String get paymentStatusText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Kutilmoqda';
      case PaymentStatus.paid:
        return 'To\'langan';
      case PaymentStatus.failed:
        return 'Xatolik';
      case PaymentStatus.refunded:
        return 'Qaytarilgan';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'Naqd pul';
      case PaymentMethod.card:
        return 'Karta';
      case PaymentMethod.bankTransfer:
        return 'Bank o\'tkazmasi';
      case PaymentMethod.digitalWallet:
        return 'Raqamli hamyon';
    }
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String unit;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'unit': unit,
    };
  }

  double get total => price * quantity;
}

class CartItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String unit;
  final double weight;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.weight,
  });

  factory CartItemModel.fromProduct(ProductModel product, int quantity) {
    return CartItemModel(
      productId: product.id,
      productName: product.name,
      productImage: product.images.isNotEmpty ? product.images.first : '',
      price: product.price,
      quantity: quantity,
      unit: product.unit,
      weight: product.weight,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      unit: json['unit'],
      weight: json['weight'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'weight': weight,
    };
  }

  double get total => price * quantity;
  double get totalWeight => weight * quantity;

  CartItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
    String? unit,
    double? weight,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
    );
  }
}
