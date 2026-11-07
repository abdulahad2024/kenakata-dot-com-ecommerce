import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../theme/app_colors.dart';

class DeliveryAddressScreen extends GetView<ProfileController> {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ডেলিভারি ঠিকানা সেটিংস'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'আপনার ডেলিভারি ঠিকানা 📍',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'অর্ডার ডেলিভারির জন্য আপনার সঠিক ঠিকানা নির্বাচন অথবা পরিবর্তন করুন।',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Preset Address Type Chips
              const Text(
                'ঠিকানার ধরণ বেছে নিন:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _addressTypeChip('বাসা 🏠', 'বাসা: '),
                  _addressTypeChip('অফিস 🏢', 'অফিস: '),
                  _addressTypeChip('অন্যান্য 📍', 'ঠিকানা: '),
                ],
              ),

              const SizedBox(height: 20),

              // Address Input Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: TextField(
                  controller: controller.addressController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                  decoration: const InputDecoration(
                    hintText: 'আপনার বাসা/ফ্ল্যাট নং, রোড নাম, এলাকা, থানা এবং জেলার নাম বিস্তারিত লিখুন...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value ? null : controller.updateDeliveryAddress,
                    icon: controller.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      controller.isLoading.value ? 'সংরক্ষণ করা হচ্ছে...' : 'ঠিকানা সংরক্ষণ করুন',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressTypeChip(String label, String prefix) {
    return ActionChip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.primary),
      labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      onPressed: () {
        if (!controller.addressController.text.startsWith(prefix)) {
          controller.addressController.text = '$prefix${controller.addressController.text}';
        }
      },
    );
  }
}
