import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommarce_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/widgets/custom_shimmer.dart';
import '../../../theme/app_colors.dart';

class BannerSection extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingBanners.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: CustomShimmer(width: double.infinity, height: 140, borderRadius: 14),
        );
      }
      if (controller.banners.isEmpty) return const SizedBox.shrink();

      return CarouselSlider(
        options: CarouselOptions(
          height: 140,
          viewportFraction: 0.9,
          enlargeCenterPage: true,
          autoPlay: true,
          onPageChanged: (index, reason) {
            controller.currentBannerIndex.value = index;
          },
        ),
        items: controller.banners.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: banner.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CustomShimmer(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 16,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primary,
                      child: const Center(
                        child: Icon(Ionicons.pricetag, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }
}
