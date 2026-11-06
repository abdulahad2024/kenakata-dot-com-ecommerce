import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class LowPriceProductsScreen extends StatelessWidget {
  const LowPriceProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ বাজেট ডিল ও ধামাকা অফার'),
      ),
      body: Obx(() {
        if (homeController.isLoadingLowPrice.value) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const CustomShimmer(width: double.infinity, height: 220, borderRadius: 16),
          );
        }

        if (homeController.lowPriceProducts.isEmpty) {
          return const Center(
            child: Text('কোনো বাজেট ডিল পাওয়া যায়নি।'),
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
          itemCount: homeController.lowPriceProducts.length,
          itemBuilder: (context, index) {
            final product = homeController.lowPriceProducts[index];
            return ProductCard(
              product: product,
              onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
            );
          },
        );
      }),
    );
  }
}
