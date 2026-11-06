import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var user = Rxn<UserModel>();

  // Login Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Register Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();

  // Change Password Controllers
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (_storage.user != null) {
      user.value = UserModel.fromJson(_storage.user!);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? _extractToken(dynamic response) {
    if (response is! Map) return null;
    if (response['token'] != null) return response['token'].toString();
    if (response['access_token'] != null) return response['access_token'].toString();
    if (response['data'] is Map) {
      final data = response['data'] as Map;
      if (data['token'] != null) return data['token'].toString();
      if (data['access_token'] != null) return data['access_token'].toString();
    }
    if (response['authorisation'] is Map && response['authorisation']['token'] != null) {
      return response['authorisation']['token'].toString();
    }
    if (response['authorization'] is Map && response['authorization']['token'] != null) {
      return response['authorization']['token'].toString();
    }
    return null;
  }

  Map<String, dynamic>? _extractUser(dynamic response) {
    if (response is! Map) return null;
    if (response['user'] is Map) return Map<String, dynamic>.from(response['user']);
    if (response['data'] is Map && response['data']['user'] is Map) {
      return Map<String, dynamic>.from(response['data']['user']);
    }
    if (response['data'] is Map && response['data']['id'] != null) {
      return Map<String, dynamic>.from(response['data']);
    }
    return null;
  }

  void _refreshUserData() {
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().fetchCart();
    }
    if (Get.isRegistered<WishlistController>()) {
      Get.find<WishlistController>().fetchWishlist();
    }
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().fetchProfile();
    }
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar('ভ্যালিডেশন এরর', 'ইমেইল ও পাসওয়ার্ড প্রদান করুন।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiClient.post(ApiUrl.login, {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      final token = _extractToken(response);
      final userMap = _extractUser(response);

      if (token != null && token.isNotEmpty) {
        await _storage.saveToken(token);
      }
      if (userMap != null) {
        await _storage.saveUser(userMap);
        user.value = UserModel.fromJson(userMap);
      }

      _refreshUserData();

      Get.snackbar('সফল', 'সফলভাবে প্রবেশ করা হয়েছে!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

      if (Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        Get.offAllNamed(AppRoutes.mainNav);
      }
    } catch (e) {
      Get.snackbar('লগইন ব্যর্থ', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        regEmailController.text.trim().isEmpty ||
        regPasswordController.text.trim().isEmpty) {
      Get.snackbar('ভ্যালিডেশন এরর', 'অনুগ্রহ করে সকল তথ্য পূরণ করুন।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiClient.post(ApiUrl.register, {
        'name': nameController.text.trim(),
        'email': regEmailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': regPasswordController.text.trim(),
      });

      final token = _extractToken(response);
      final userMap = _extractUser(response);

      if (token != null && token.isNotEmpty) {
        await _storage.saveToken(token);
      }
      if (userMap != null) {
        await _storage.saveUser(userMap);
        user.value = UserModel.fromJson(userMap);
      }

      _refreshUserData();

      Get.snackbar('সফল', 'রেজিস্ট্রেশন সফল হয়েছে!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

      if (Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        Get.offAllNamed(AppRoutes.mainNav);
      }
    } catch (e) {
      Get.snackbar('রেজিস্ট্রেশন ব্যর্থ', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    if (oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty) {
      Get.snackbar('ভ্যালিডেশন এরর', 'পুরাতন ও নতুন উভয় পাসওয়ার্ড লিখুন।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _apiClient.post(ApiUrl.changePassword, {
        'old_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
      });

      Get.back();
      Get.snackbar('সফল', 'পাসওয়ার্ড পরিবর্তিত হয়েছে!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('এরর', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.logout();
    user.value = null;

    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().cart.value = null;
    }
    if (Get.isRegistered<WishlistController>()) {
      Get.find<WishlistController>().wishlistItems.clear();
    }
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().user.value = null;
    }

    Get.offAllNamed(AppRoutes.login);
  }
}
