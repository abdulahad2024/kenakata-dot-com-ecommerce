import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommarce_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/utils/image_helper.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';

/// onSeeAll দিলে সবার শেষে "সব দেখুন" গোল বাটন আসবে
class HorizontalCategory extends StatelessWidget {
  const HorizontalCategory({
    super.key,
    required this.controller,
    this.onSeeAll,
  });

  final HomeController controller;
  final VoidCallback? onSeeAll;

  static const double _ringSize = 66;
  static const double _itemWidth = 76;

  // প্রতিটা রিংয়ের আলাদা রং
  static const List<Color> _accents = [
    Color(0xFFF0997B), // হালকা কমলা
    Color(0xFFAFA9EC), // হালকা বেগুনি
    Color(0xFF5DCAA5), // হালকা সবুজ
    Color(0xFFED93B1), // হালকা গোলাপি
    Color(0xFF85B7EB), // হালকা নীল
    Color(0xFFFAC775), // হালকা হলুদ
  ];

  Widget _ring({required Color color, required Widget child}) {
    return Container(
      width: _ringSize,
      height: _ringSize,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
      ),
      child: ClipOval(child: child),
    );
  }

  Widget _label(String text, {Color? color}) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      child: Obx(() {
        // ---------- লোডিং ----------
        if (controller.isLoadingCategories.value) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  CustomShimmer(
                      width: _ringSize, height: _ringSize, borderRadius: 33),
                  SizedBox(height: 8),
                  CustomShimmer(width: 44, height: 10, borderRadius: 5),
                ],
              ),
            ),
          );
        }

        // ---------- খালি ----------
        if (controller.categories.isEmpty) {
          return const Center(child: Text('কোনো ক্যাটাগরি পাওয়া যায়নি'));
        }

        // ---------- তালিকা ----------
        final count = controller.categories.length;
        final showSeeAll = onSeeAll != null;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          itemCount: count + (showSeeAll ? 1 : 0),
          itemBuilder: (context, index) {
            // শেষে: সব দেখুন
            if (showSeeAll && index == count) {
              return GestureDetector(
                onTap: onSeeAll,
                child: SizedBox(
                  width: _itemWidth,
                  child: Column(
                    children: [
                      _ring(
                        color: AppColors.primary,
                        child: Container(
                          color: AppColors.primary.withAlpha(24),
                          alignment: Alignment.center,
                          child: Icon(Ionicons.arrowForward,
                              color: AppColors.primary, size: 24),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _label('সব দেখুন', color: AppColors.primary),
                    ],
                  ),
                ),
              );
            }

            final cat = controller.categories[index];
            final hasImage = cat.image != null && cat.image!.isNotEmpty;
            final accent = _accents[index % _accents.length];

            return GestureDetector(
              onTap: () =>
                  Get.toNamed(AppRoutes.categoryProducts, arguments: cat),
              child: SizedBox(
                width: _itemWidth,
                child: Column(
                  children: [
                    _ring(
                      color: accent,
                      child: Container(
                        color: accent.withAlpha(28),
                        child: hasImage
                            ? CachedNetworkImage(
                          imageUrl: ImageHelper.getImageUrl(cat.image),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const CustomShimmer(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: 0,
                          ),
                          errorWidget: (context, url, error) => Icon(
                              Ionicons.grid,
                              color: accent,
                              size: 24),
                        )
                            : Icon(Ionicons.grid, color: accent, size: 24),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _label(cat.name),
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