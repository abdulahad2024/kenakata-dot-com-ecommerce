import 'package:ecommarce_app/app/modules/home/widgets/banner_section.dart';
import 'package:ecommarce_app/app/modules/home/widgets/home_app_bar.dart';
import 'package:ecommarce_app/app/modules/home/widgets/home_search_bar.dart';
import 'package:ecommarce_app/app/modules/home/widgets/horizental_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ionicons/ionicons.dart';
import '../controllers/home_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';
import '../widgets/active_store.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.fetchHomeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSearchBar(),

              BannerSection(controller: controller),

              const SizedBox(height: 20),

              // Categories Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ক্যাটাগরি সমূহ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.categories),
                      child: const Text(
                        'সব দেখুন',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              HorizontalCategory(controller: controller),

              const SizedBox(height: 15),

              // Active Stores Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'সেরা শপসমূহ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              ActiveStore(controller: controller),

              const SizedBox(height: 24),

              // Low Price Deals
              Obx(() {
                if (controller.lowPriceProducts.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Ionicons.flash, color: AppColors.secondaryDark, size: 22),
                              SizedBox(width: 6),
                              Text(
                                'বাজেট ডিল ও অফার',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.lowPriceProducts),
                            child: const Text(
                              'সব দেখুন',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.lowPriceProducts.length,
                        itemBuilder: (context, index) {
                          final product = controller.lowPriceProducts[index];
                          return Container(
                            width: 155,
                            margin: const EdgeInsets.only(right: 12),
                            child: ProductCard(
                              product: product,
                              onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }),

              // All Products Header & Grid (Max 6 on Home)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'সকল প্রোডাক্ট',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.allProducts),
                      child: const Text(
                        'সব দেখুন',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),


              Obx(() {
                if (controller.isLoadingAllProducts.value) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                if (controller.allProducts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('কোনো প্রোডাক্ট পাওয়া যায়নি।')),
                  );
                }

                // Show max 6 products on Home screen
                final homeProducts = controller.allProducts.take(6).toList();

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: homeProducts.length,
                      itemBuilder: (context, index) {
                        final product = homeProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
                        );
                      },
                    ),
                    if (controller.allProducts.length > 6) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () => Get.toNamed(AppRoutes.allProducts),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('আরও প্রোডাক্ট দেখুন', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),

              const SizedBox(height: 130),

            ],
          ),
        ),
      ),
    );
  }
}

