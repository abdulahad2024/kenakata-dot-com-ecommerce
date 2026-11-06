import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../../../data/models/category_model.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late final CategoryController controller;
  late final CategoryModel category;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CategoryController>();
    category = Get.arguments as CategoryModel;
    controller.fetchCategoryProducts(category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Obx(() {
        if (controller.isLoadingProducts.value) {
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

        if (controller.categoryProducts.isEmpty) {
          return const Center(child: Text('এই ক্যাটাগরিতে কোনো প্রোডাক্ট পাওয়া যায়নি।'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.categoryProducts.length,
          itemBuilder: (context, index) {
            final product = controller.categoryProducts[index];
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
