import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final StorageService _storage = Get.find<StorageService>();

  var currentIndex = 0.obs;

  final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'হাজারো শপ ও প্রোডাক্ট',
      description: 'এক ক্লিকেই বেছে নিন সেরা ভেরিফাইড শপের আসল সব প্রোডাক্ট।',
      icon: Icons.storefront_rounded,
    ),
    OnboardingItem(
      title: 'সহজ ও দ্রুত কেনাকাটা',
      description: 'সহজেই পছন্দের জিনিস কার্টে রাখুন এবং অর্ডার ট্রাক করুন।',
      icon: Icons.shopping_bag_outlined,
    ),
    OnboardingItem(
      title: 'দ্রুত হোম ডেলিভারি',
      description: 'আপনার দোরগোড়ায় দ্রুত ও সুরক্ষিত ডেলিভারি নিশ্চিন্তে পান।',
      icon: Icons.local_shipping_outlined,
    ),
  ];

  void nextPage() {
    if (currentIndex.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() {
    _storage.setFirstTimeCompleted();
    Get.offAllNamed(AppRoutes.mainNav);
  }
}
