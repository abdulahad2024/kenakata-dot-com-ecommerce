import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/cart_controller.dart';
import '../../../theme/app_colors.dart';

class CheckoutScreen extends GetView<CartController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('চেকআউট ও অর্ডার কনফার্ম'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Order Items Summary Section
                    const Text(
                      'অর্ডারের পণ্যসমূহ 🛍️',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final cart = controller.cart.value;
                      if (cart == null || cart.items.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('কার্টে কোনো আইটেম নেই।'),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: cart.items.length,
                          separatorBuilder: (context, index) => const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: item.product.image!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey),
                                  ),
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
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)} × ${item.quantity}',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // 2. Contact Phone Number Section
                    const Text(
                      'যোগাযোগের ফোন নম্বর 📞',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: TextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'আপনার ১১ ডিজিটের ফোন নম্বর লিখুন...',
                          prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Delivery Address Section
                    const Text(
                      'ডেলিভারি ঠিকানা 📍',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: TextField(
                        controller: controller.addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'আপনার বিস্তারিত রোড নং, বাড়ি নং, এলাকা, জেলা লিখুন...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 4. Payment Method Section
                    const Text(
                      'পেমেন্ট পদ্ধতি 💳',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.payments_outlined, color: AppColors.primary, size: 28),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ক্যাশ অন ডেলিভারি (COD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('পণ্য হাতে পেয়ে মূল্য পরিশোধ করুন', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 5. Bill Summary Calculation Breakdown
                    Obx(() {
                      final cart = controller.cart.value;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('সাবটোটাল', style: TextStyle(color: AppColors.textSecondary)),
                                Text('\$${cart?.subtotal.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('ডেলিভারি চার্জ', style: TextStyle(color: AppColors.textSecondary)),
                                Text('\$${cart?.deliveryFee.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('সর্বমোট মূল্য', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                Text(
                                  '\$${cart?.grandTotal.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Confirm Button Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -2)),
                ],
              ),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.checkoutOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('অর্ডার কনফার্ম করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
