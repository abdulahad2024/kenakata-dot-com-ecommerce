import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ionicons/ionicons.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.search),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withAlpha(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Ionicons.search, color: AppColors.primary),
              SizedBox(width: 10),
              Text(
                'প্রোডাক্ট, শপ বা ক্যাটাগরি খুঁজুন...',
                style: TextStyle(color: AppColors.textHint, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
