import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/cart_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CartController>();
    controller.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার শপিং কার্ট'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchCart,
        child: Obx(() {
          if (controller.isLoading.value) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: CustomShimmer(width: double.infinity, height: 90, borderRadius: 16),
              ),
            );
          }

          final cart = controller.cart.value;
          if (cart == null || cart.items.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        'আপনার কার্ট খালি!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'পছন্দের পণ্য কার্টে যোগ করে কেনাকাটা শুরু করুন।',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed(AppRoutes.mainNav),
                        child: const Text('কেনাকাটা শুরু করুন'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: item.product.image != null && item.product.image!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(imageUrl: item.product.image!, fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.image, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, size: 20),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    controller.updateQuantity(item.cartId, item.quantity - 1);
                                  } else {
                                    controller.removeCartItem(item.cartId);
                                  }
                                },
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primary),
                                onPressed: () => controller.updateQuantity(item.cartId, item.quantity + 1),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
                            onPressed: () => controller.removeCartItem(item.cartId),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Order Summary Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('সাবটোটাল', style: TextStyle(color: AppColors.textSecondary)),
                        Text('\$${cart.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ডেলিভারি চার্জ', style: TextStyle(color: AppColors.textSecondary)),
                        Text('\$${cart.deliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('সর্বমোট মূল্য', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${cart.grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.checkout),
                        child: const Text('অর্ডার চেকআউট করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 130),

                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
