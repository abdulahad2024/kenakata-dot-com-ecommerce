import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  Color get _light => Color.lerp(AppColors.primary, Colors.white, 0.22)!;

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();

    return Scaffold(
      body: Obx(() {
        final currentUser = controller.user.value;
        final isLoggedIn = storage.isLoggedIn || currentUser != null;
        if (!isLoggedIn) {
          return _buildLoggedOut();
        }
        return _buildLoggedIn(context);
      }),
    );
  }

  // ---------------------------------------------------------------
  // লগইন করা নেই
  // ---------------------------------------------------------------
  Widget _buildLoggedOut() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withAlpha(22),
                  ),
                  child: Icon(Icons.person_outline,
                      size: 46, color: AppColors.primary),
                ),
                const SizedBox(height: 22),
                const Text(
                  'প্রোফাইল দেখতে লগইন করুন',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'অর্ডার, ঠিকানা এবং উইশলিস্ট ম্যানেজ করুন।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                _gradientButton(
                  label: 'লগইন / রেজিস্টার করুন',
                  onTap: () => Get.toNamed(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // লগইন করা আছে
  // ---------------------------------------------------------------
  Widget _buildLoggedIn(BuildContext context) {
    final user = controller.user.value;
    final name = (user?.name != null && user!.name!.isNotEmpty)
        ? user.name!
        : 'ব্যবহারকারী';
    final initial = name.characters.first.toUpperCase();
    final hasPhone = user?.phone != null && user!.phone!.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120), // নিচের নেভ বারের জায়গা
        child: Column(
          children: [
            // ---------- গ্রেডিয়েন্ট হেডার ----------
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 20, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_light, AppColors.primary],
                ),
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(70),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'আমার অ্যাকাউন্ট',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: AppColors.primary.withAlpha(30),
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            if ((user?.email ?? '').isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                user!.email!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withAlpha(220),
                                ),
                              ),
                            ],
                            if (hasPhone) ...[
                              const SizedBox(height: 2),
                              Text(
                                user.phone ?? '',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.white.withAlpha(200),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Get.toNamed(AppRoutes.editProfile),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.edit_outlined,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---------- মেনু ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('আমার কেনাকাটা'),
                  _card([
                    _menuTile(
                      Icons.shopping_bag_outlined,
                      'অর্ডার হিস্ট্রি',
                          () => Get.toNamed(AppRoutes.orderHistory),
                    ),
                    _divider(),
                    _menuTile(
                      Icons.location_on_outlined,
                      'ডেলিভারি ঠিকানা',
                          () => Get.toNamed(AppRoutes.deliveryAddress),
                    ),
                  ]),
                  const SizedBox(height: 22),
                  _sectionTitle('অ্যাকাউন্ট সেটিংস'),
                  _card([
                    _menuTile(
                      Icons.edit_outlined,
                      'প্রোফাইল এডিট',
                          () => Get.toNamed(AppRoutes.editProfile),
                    ),
                    _divider(),
                    _menuTile(
                      Icons.lock_outline,
                      'পাসওয়ার্ড পরিবর্তন',
                          () => Get.toNamed(AppRoutes.changePassword),
                    ),
                  ]),
                  const SizedBox(height: 26),

                  // ---------- লগ আউট ----------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: controller.logout,
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'লগ আউট করুন',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.error.withAlpha(24),
                        foregroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ---------- অ্যাকাউন্ট মুছুন ----------
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _showDeleteConfirmDialog(context),
                      icon: Icon(Icons.delete_outline,
                          size: 18, color: Colors.grey[500]),
                      label: Text(
                        'একাউন্ট মুছুন',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // ছোট ছোট অংশ
  // ---------------------------------------------------------------
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.grey[600],
      ),
    ),
  );

  Widget _divider() => Divider(
    height: 1,
    indent: 70,
    endIndent: 16,
    color: Colors.grey.shade200,
  );

  Widget _card(List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTile(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradientButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_light, AppColors.primary],
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
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'একাউন্ট মুছুন',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'আপনি কি নিশ্চিত যে একাউন্ট মুছে ফেলতে চান? এই কাজটি আর ফিরিয়ে আনা সম্ভব হবে না।',
          style: TextStyle(height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              controller.deleteAccount();
            },
            child: const Text('মুছে ফেলুন'),
          ),
        ],
      ),
    );
  }
}