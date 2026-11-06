import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final StorageService _storage = Get.find<StorageService>();

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.forward();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (_storage.isFirstTime) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else {
        Get.offAllNamed(AppRoutes.mainNav);
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
