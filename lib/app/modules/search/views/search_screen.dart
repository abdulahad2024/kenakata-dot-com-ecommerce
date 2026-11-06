import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../controllers/search_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class SearchScreen extends GetView<SearchPageController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withAlpha(50)),
            ),
            child: TextField(
              controller: controller.searchTextController,
              autofocus: true,
              onChanged: controller.filterProducts,
              decoration: InputDecoration(
                hintText: 'প্রোডাক্ট, শপ বা ক্যাটাগরি খুঁজুন...',
                prefixIcon: const Icon(Ionicons.search, color: AppColors.primary, size: 20),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Ionicons.close, color: Colors.grey, size: 20),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink()),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
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

        // Search Query Empty -> Show Popular Tags
        if (controller.searchQuery.value.isEmpty) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Ionicons.flame, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'জনপ্রিয় সার্চ ট্যাগসমূহ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.popularTags.map((tag) {
                    return ActionChip(
                      label: Text(tag),
                      avatar: const Icon(Ionicons.search, size: 14, color: AppColors.primary),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: AppColors.primary.withAlpha(40)),
                      labelStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                      onPressed: () => controller.onTagSelected(tag),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        // Search Query Provided -> Show Filtered Results
        if (controller.filteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Ionicons.search, size: 70, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  '"${controller.searchQuery.value}" এর কোনো প্রোডাক্ট পাওয়া যায়নি',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text('অন্য কোনো নাম বা কিওয়ার্ড দিয়ে চেষ্টা করুন।', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'খুঁজে পাওয়া গেছে: ${controller.filteredProducts.length} টি প্রোডাক্ট',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
