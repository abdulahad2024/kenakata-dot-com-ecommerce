import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_colors.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  static const Color _fill = Color(0xFFF5F6F8);

  OutlineInputBorder _border([Color? color, double width = 1.5]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: color == null
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
      suffixIcon: suffix,
      filled: true,
      fillColor: _fill,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppColors.primary),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                  color: _fill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 17, color: Colors.black87),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- হেডার ----------
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.primary.withAlpha(22),
                    border:
                    Border.all(color: AppColors.primary.withAlpha(30)),
                  ),
                  child: Image.asset('assets/images/logo.png',
                      fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),
                const Text(
                  'নতুন অ্যাকাউন্ট তৈরি করুন',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'কেনাকাটা শুরু করতে আপনার তথ্যগুলো পূরণ করুন।',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // ---------- ফর্ম ----------
                _label('পূর্ণ নাম'),
                TextField(
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoration(
                    hint: 'আপনার নাম লিখুন',
                    icon: Ionicons.person,
                  ),
                ),
                const SizedBox(height: 18),

                _label('ফোন নম্বর'),
                TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    hint: '01XXXXXXXXX',
                    icon: Ionicons.call,
                  ),
                ),
                const SizedBox(height: 18),

                _label('ইমেইল এড্রেস'),
                TextField(
                  controller: controller.regEmailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    hint: 'example@email.com',
                    icon: Ionicons.mail,
                  ),
                ),
                const SizedBox(height: 18),

                _label('পাসওয়ার্ড'),
                Obx(
                      () => TextField(
                    controller: controller.regPasswordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    decoration: _decoration(
                      hint: 'কমপক্ষে ৬ অক্ষর',
                      icon: Ionicons.lockOpen,
                      suffix: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[500],
                          size: 21,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ---------- বাটন ----------
                Obx(() {
                  final loading = controller.isLoading.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Opacity(
                      opacity: loading ? 0.7 : 1,
                      child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.lerp(
                                    AppColors.primary, Colors.white, 0.22)!,
                                AppColors.primary,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(90),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: loading ? null : controller.register,
                            child: Center(
                              child: loading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : const Text(
                                'রেজিস্ট্রেশন সম্পন্ন করুন',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 22),

                // ---------- লগইন লিংক ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ইতিমধ্যে অ্যাকাউন্ট আছে?',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'লগইন করুন',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}