import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- হেডার ----------
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primary.withAlpha(22),
                    border:
                    Border.all(color: AppColors.primary.withAlpha(30)),
                  ),
                  child: Image.asset('assets/images/logo.png',
                      fit: BoxFit.contain),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ফিরে আসার জন্য স্বাগতম!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'আপনার কার্ট, উইশলিস্ট ও অর্ডার দেখতে সাইন ইন করুন।',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // ---------- ফর্ম ----------
                _label('ইমেইল এড্রেস'),
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration(
                    hint: 'example@email.com',
                    icon: Icons.email_outlined,
                  ),
                ),
                const SizedBox(height: 18),

                _label('পাসওয়ার্ড'),
                Obx(
                      () => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (!controller.isLoading.value) controller.login();
                    },
                    decoration: _decoration(
                      hint: 'আপনার পাসওয়ার্ড লিখুন',
                      icon: Icons.lock_outline,
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
                const SizedBox(height: 32),

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
                            onTap: loading ? null : controller.login,
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
                                'সাইন ইন করুন',
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
                const SizedBox(height: 24),

                // ---------- রেজিস্টার লিংক ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'অ্যাকাউন্ট নেই?',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'নতুন অ্যাকাউন্ট খুলুন',
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