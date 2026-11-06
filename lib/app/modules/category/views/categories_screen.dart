import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/category_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class CategoriesScreen extends GetView<CategoryController> {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সকল ক্যাটাগরি')),
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => const CustomShimmer(width: double.infinity, height: 100, borderRadius: 16),
          );
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text('কোনো ক্যাটাগরি পাওয়া যায়নি।'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.categoryProducts, arguments: cat),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: cat.image != null && cat.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(imageUrl: cat.image!, fit: BoxFit.cover),
                            )
                          : const Icon(Icons.category_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
