import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/store_controller.dart';
import '../../../data/models/store_model.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  late final StoreController controller;
  late final StoreModel store;

  @override
  void initState() {
    super.initState();
    controller = Get.find<StoreController>();
    store = Get.arguments as StoreModel;
    controller.fetchStoreDetails(store.sellerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                store.storeName,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [
                  Shadow(blurRadius: 10, color: Colors.black.withAlpha(200), offset: const Offset(0, 2)),
                ]),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  store.banner != null && store.banner!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: store.banner!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CustomShimmer(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: 0,
                          ),
                          errorWidget: (context, url, error) => Container(color: AppColors.primary),
                        )
                      : Container(color: AppColors.primary),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withAlpha(180)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha(25),
                    ),
                    child: store.logo != null && store.logo!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: store.logo!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CustomShimmer(width: 60, height: 60, borderRadius: 30),
                              errorWidget: (context, url, error) => const Icon(Icons.store, color: AppColors.primary, size: 30),
                            ),
                          )
                        : const Icon(Icons.store, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(store.storeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('${store.rating} স্টার রেটিং', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('এই শপের সকল প্রোডাক্ট', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Obx(() {
            if (controller.storeProducts.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text('এই শপে কোনো প্রোডাক্ট পাওয়া যায়নি।')),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = controller.storeProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
                    );
                  },
                  childCount: controller.storeProducts.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
