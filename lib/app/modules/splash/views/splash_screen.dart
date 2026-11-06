import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../theme/app_colors.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),

              // Animated Center Logo & Branding
              FadeTransition(
                opacity: controller.fadeAnimation,
                child: ScaleTransition(
                  scale: controller.scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          size: 70,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App Name
                      const Text(
                        'মাল্টিভেন্ডোর ই-কমার্স',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Tagline
                      Text(
                        'আপনার বিশ্বস্ত অনলাইন শপিং পার্টনার',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(220),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Loading Indicator & Version
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withAlpha(220),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
