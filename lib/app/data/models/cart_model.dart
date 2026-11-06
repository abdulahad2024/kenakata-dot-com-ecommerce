import 'product_model.dart';
import '../../../../core/utils/image_helper.dart';

class CartItemModel {
  final int cartId;
  final int productId;
  final int quantity;
  final double price;
  final ProductModel product;

  CartItemModel({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    dynamic rawProd = json['product'] ?? json['item'] ?? json['product_data'];
    ProductModel prod;

    if (rawProd is Map<String, dynamic>) {
      prod = ProductModel.fromJson(rawProd);
    } else {
      final rawImage = json['image']?.toString() ??
          json['product_image']?.toString() ??
          json['thumbnail']?.toString() ??
          json['photo']?.toString();

      prod = ProductModel(
        id: json['product_id'] is int
            ? json['product_id']
            : (int.tryParse(json['product_id']?.toString() ?? '0') ?? 0),
        title: json['product_name']?.toString() ??
            json['title']?.toString() ??
            json['name']?.toString() ??
            'প্রোডাক্ট',
        price: double.tryParse(json['price']?.toString() ??
                json['unit_price']?.toString() ??
                '0') ??
            0.0,
        image: ImageHelper.getImageUrl(rawImage),
      );
    }

    final int cId = json['cart_id'] is int
        ? json['cart_id']
        : (json['id'] is int
            ? json['id']
            : (int.tryParse(json['cart_id']?.toString() ?? json['id']?.toString() ?? '0') ?? 0));

    final int pId = json['product_id'] is int
        ? json['product_id']
        : (prod.id != 0 ? prod.id : (int.tryParse(json['product_id']?.toString() ?? '0') ?? 0));

    final int qty = json['quantity'] is int
        ? json['quantity']
        : (json['qty'] is int
            ? json['qty']
            : (int.tryParse(json['quantity']?.toString() ?? json['qty']?.toString() ?? '1') ?? 1));

    final double pPrice = double.tryParse(
            json['price']?.toString() ?? json['unit_price']?.toString() ?? '0') ??
        prod.price;

    return CartItemModel(
      cartId: cId,
      productId: pId,
      quantity: qty,
      price: pPrice,
      product: prod,
    );
  }

  double get totalPrice => price * quantity;
}

class CartModel {
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double grandTotal;

  CartModel({
    required this.items,
    required this.subtotal,
    this.deliveryFee = 50.0,
    required this.grandTotal,
  });

  factory CartModel.fromJson(dynamic json) {
    List<CartItemModel> cartItems = [];
    double calculatedSubtotal = 0.0;

    List? rawList;
    if (json is List) {
      rawList = json;
    } else if (json is Map) {
      if (json['data'] is List) {
        rawList = json['data'] as List;
      } else if (json['items'] is List) {
        rawList = json['items'] as List;
      } else if (json['cart'] is List) {
        rawList = json['cart'] as List;
      } else if (json['cart_items'] is List) {
        rawList = json['cart_items'] as List;
      } else if (json['data'] is Map) {
        final dataMap = json['data'] as Map;
        if (dataMap['items'] is List) {
          rawList = dataMap['items'] as List;
        } else if (dataMap['cart'] is List) {
          rawList = dataMap['cart'] as List;
        } else if (dataMap['cart_items'] is List) {
          rawList = dataMap['cart_items'] as List;
        }
      } else if (json['cart'] is Map) {
        final cartMap = json['cart'] as Map;
        if (cartMap['items'] is List) {
          rawList = cartMap['items'] as List;
        } else if (cartMap['cart_items'] is List) {
          rawList = cartMap['cart_items'] as List;
        }
      }
    }

    if (rawList != null) {
      for (var item in rawList) {
        if (item is Map<String, dynamic>) {
          cartItems.add(CartItemModel.fromJson(item));
        }
      }
    }

    double apiSubtotal = 0.0;
    if (json is Map) {
      apiSubtotal = double.tryParse(json['subtotal']?.toString() ??
              json['sub_total']?.toString() ??
              json['total']?.toString() ??
              json['data']?['subtotal']?.toString() ??
              '0') ??
          0.0;
    }

    for (var item in cartItems) {
      calculatedSubtotal += item.totalPrice;
    }

    final double finalSubtotal = apiSubtotal > 0 ? apiSubtotal : calculatedSubtotal;
    final double delivery = cartItems.isNotEmpty ? 50.0 : 0.0;

    return CartModel(
      items: cartItems,
      subtotal: finalSubtotal,
      deliveryFee: delivery,
      grandTotal: finalSubtotal + delivery,
    );
  }
}
