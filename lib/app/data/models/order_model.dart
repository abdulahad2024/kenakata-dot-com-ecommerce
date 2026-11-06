import 'cart_model.dart';

class OrderModel {
  final int id;
  final String orderNumber;
  final String status;
  final double totalAmount;
  final String deliveryAddress;
  final String createdAt;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<CartItemModel> parsedItems = [];
    if (json['items'] is List) {
      parsedItems = (json['items'] as List).map((e) => CartItemModel.fromJson(e)).toList();
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      orderNumber: json['order_number']?.toString() ?? json['id']?.toString() ?? '#ORD-${json['id']}',
      status: json['status']?.toString() ?? 'Pending',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? json['total']?.toString() ?? '0') ?? 0.0,
      deliveryAddress: json['delivery_address']?.toString() ?? json['address']?.toString() ?? 'N/A',
      createdAt: json['created_at']?.toString() ?? json['date']?.toString() ?? 'Recently',
      items: parsedItems,
    );
  }
}

class OrderStatusCountsModel {
  final int pending;
  final int processing;
  final int delivered;
  final int cancelled;

  OrderStatusCountsModel({
    this.pending = 0,
    this.processing = 0,
    this.delivered = 0,
    this.cancelled = 0,
  });

  factory OrderStatusCountsModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusCountsModel(
      pending: int.tryParse(json['pending']?.toString() ?? '0') ?? 0,
      processing: int.tryParse(json['processing']?.toString() ?? '0') ?? 0,
      delivered: int.tryParse(json['delivered']?.toString() ?? json['completed']?.toString() ?? '0') ?? 0,
      cancelled: int.tryParse(json['cancelled']?.toString() ?? '0') ?? 0,
    );
  }
}
