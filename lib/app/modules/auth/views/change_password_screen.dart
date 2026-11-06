import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_colors.dart';

class ChangePasswordScreen extends GetView<AuthController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('পাসওয়ার্ড পরিবর্তন')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: controller.oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'বর্তমান পাসওয়ার্ড',
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'নতুন পাসওয়ার্ড',
                prefixIcon: Icon(Icons.lock_reset, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.changePassword,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('পাসওয়ার্ড আপডেট করুন'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
