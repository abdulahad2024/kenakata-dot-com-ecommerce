import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wishlist_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পছন্দের তালিকা'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => const CustomShimmer(width: double.infinity, height: 220, borderRadius: 16),
          );
        }

        if (controller.wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text('কোনো সংরক্ষিত পণ্য নেই', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('আপনার পছন্দের পণ্যগুলো এখানে সেভ করে রাখতে পারেন।', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final product = controller.wishlistItems[index];
            return ProductCard(
              product: product,
              isWishlisted: true,
              onWishlistToggle: () => controller.toggleWishlist(product.id),
              onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
            );
          },
        );
      }),
    );
  }
}
