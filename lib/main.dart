import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/providers/api_client.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';
import 'core/constants/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage Service & API Client
  await Get.putAsync(() => StorageService().init());
  Get.put(ApiClient());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
