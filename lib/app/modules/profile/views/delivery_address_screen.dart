import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../theme/app_colors.dart';

class DeliveryAddressScreen extends GetView<ProfileController> {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ডেলিভারি ঠিকানা')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller.addressController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'আপনার বিস্তারিত রোড নং, বাড়ি নং, এলাকা, জেলা লিখুন...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.location_on_outlined, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.updateDeliveryAddress,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ঠিকানা সংরক্ষণ করুন'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
