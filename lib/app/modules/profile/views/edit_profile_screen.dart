import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../theme/app_colors.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('প্রোফাইল এডিট')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'পূর্ণ নাম',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'ফোন নম্বর',
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.updateProfile,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('পরিবর্তন সংরক্ষণ করুন'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
