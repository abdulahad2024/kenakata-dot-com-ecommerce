import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommarce_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/utils/image_helper.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';

class ActiveStore extends StatelessWidget {
  const ActiveStore({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  static const double _cardWidth = 150;
  static const double _cardHeight = 128;
  static const double _bandHeight = 48;
  static const double _logoSize = 54;

  // স্টোর কার্ডের উপরের ব্যান্ডের হালকা রং
  static const List<Color> _bands = [
    Color(0xFFF5C4B3),
    Color(0xFFCECBF6),
    Color(0xFF9FE1CB),
    Color(0xFFF4C0D1),
    Color(0xFFB5D4F4),
    Color(0xFFFAC775),
  ];

  Widget _logoFallback() => Container(
    color: AppColors.primary.withAlpha(25),
    alignment: Alignment.center,
    child: Icon(Ionicons.storefront, color: AppColors.primary, size: 24),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight + 16,
      child: Obx(() {
        // ---------- লোডিং ----------
        if (controller.isLoadingStores.value) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            itemCount: 4,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 12),
              child: CustomShimmer(
                  width: _cardWidth, height: _cardHeight, borderRadius: 18),
            ),
          );
        }

        if (controller.activeStores.isEmpty) return const SizedBox.shrink();

        // ---------- তালিকা ----------
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.activeStores.length,
          itemBuilder: (context, index) {
            final store = controller.activeStores[index];
            final hasLogo = store.logo != null && store.logo!.isNotEmpty;
            final band = _bands[index % _bands.length];

            return GestureDetector(
              onTap: () =>
                  Get.toNamed(AppRoutes.storeDetails, arguments: store),
              child: Container(
                width: _cardWidth,
                height: _cardHeight,
                margin: const EdgeInsets.only(right: 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(16),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // উপরের রঙিন ব্যান্ড
                        Container(height: _bandHeight, color: band),
                        // নাম ও স্ট্যাটাস
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 34, 10, 8),
                            child: Column(
                              children: [
                                Text(
                                  store.storeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2DB87A),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'সক্রিয় স্টোর',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ব্যান্ডের উপর ভাসমান লোগো
                    Positioned(
                      top: _bandHeight - _logoSize / 2,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: _logoSize,
                          height: _logoSize,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(24),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: hasLogo
                                ? CachedNetworkImage(
                              imageUrl:
                              ImageHelper.getImageUrl(store.logo),
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const CustomShimmer(
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: 0,
                              ),
                              errorWidget: (context, url, error) =>
                                  _logoFallback(),
                            )
                                : _logoFallback(),
                          ),
                        ),
                      ),
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