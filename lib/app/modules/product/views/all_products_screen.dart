import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('সকল প্রোডাক্ট'),
      ),
      body: Obx(() {
        if (homeController.isLoadingAllProducts.value) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 8,
            itemBuilder: (context, index) => const CustomShimmer(width: double.infinity, height: 220, borderRadius: 16),
          );
        }

        if (homeController.allProducts.isEmpty) {
          return const Center(
            child: Text('কোনো প্রোডাক্ট পাওয়া যায়নি।'),
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
          itemCount: homeController.allProducts.length,
          itemBuilder: (context, index) {
            final product = homeController.allProducts[index];
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
