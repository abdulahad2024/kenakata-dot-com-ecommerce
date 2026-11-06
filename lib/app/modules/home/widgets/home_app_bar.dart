import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ionicons/ionicons.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.onSearchTap,
    this.onNotificationTap,
    this.hasUnread = true,
  });

  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final bool hasUnread;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      scrolledUnderElevation: 3,
      shadowColor: Colors.black.withAlpha(30),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      titleSpacing: 16,
      title: Row(
        children: [
          // লোগো
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withAlpha(36),
                  AppColors.primary.withAlpha(10),
                ],
              ),
              border: Border.all(color: AppColors.primary.withAlpha(30)),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),

          // নাম ও ট্যাগলাইন
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'কেনাকাটা ডটকম',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Ionicons.flash, size: 12, color: AppColors.primary),
                    const SizedBox(width: 3),
                    const Flexible(
                      child: Text(
                        'সেরা ডিল ও আকর্ষণীয় অফার',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _ActionButton(
          icon: Ionicons.search,
          onTap: onSearchTap ?? () {
           Get.toNamed(AppRoutes.search);

          },
        ),
        const SizedBox(width: 8),
        _ActionButton(
          icon: Ionicons.notifications,
          showDot: hasUnread,
          onTap: onNotificationTap ?? () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 22, color: Colors.black87),
              if (showDot)
                Positioned(
                  top: 9,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade100, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}