import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/product_model.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../routes/app_routes.dart';

class WishlistController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  var isLoading = false.obs;
  var wishlistItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (_storage.isLoggedIn) {
      fetchWishlist();
    }
  }

  Future<void> fetchWishlist() async {
    if (!_storage.isLoggedIn) return;

    try {
      isLoading.value = true;
      final response = await _apiClient.get(ApiUrl.getWishlist);
      if (response is List) {
        wishlistItems.assignAll(response.map((e) => ProductModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        wishlistItems.assignAll((response['data'] as List).map((e) => ProductModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleWishlist(int productId) async {
    if (!_storage.isLoggedIn) {
      await Get.toNamed(AppRoutes.login);
      if (!_storage.isLoggedIn) return;
    }

    try {
      await _apiClient.post(ApiUrl.toggleWishlist, {'product_id': productId});
      fetchWishlist();
      Get.snackbar('উইশলিস্ট আপডেট', 'আইটেম স্টেটাস পরিবর্তন করা হয়েছে',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.indigo, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('ত্রুটি', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
