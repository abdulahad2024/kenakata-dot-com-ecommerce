import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (_storage.isLoggedIn) {
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    if (!_storage.isLoggedIn) return;

    try {
      isLoading.value = true;
      final response = await _apiClient.get(ApiUrl.profile);
      dynamic userMap;
      if (response is Map && response.containsKey('user')) {
        userMap = response['user'];
      } else {
        userMap = response;
      }

      if (userMap is Map<String, dynamic>) {
        user.value = UserModel.fromJson(userMap);
        await _storage.saveUser(userMap);

        nameController.text = user.value?.name ?? '';
        phoneController.text = user.value?.phone ?? '';
        addressController.text = user.value?.deliveryAddress ?? '';
      }
    } catch (_) {
      if (_storage.user != null) {
        user.value = UserModel.fromJson(_storage.user!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      await _apiClient.post(ApiUrl.updateProfile, {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
      });

      Get.back();
      fetchProfile();
      Get.snackbar('Success', 'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeliveryAddress() async {
    if (addressController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Address cannot be empty.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await _apiClient.post(ApiUrl.updateDeliveryAddress, {
        'delivery_address': addressController.text.trim(),
      });

      Get.back();
      fetchProfile();
      Get.snackbar('Success', 'Delivery address updated!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await _apiClient.post(ApiUrl.deleteAccount, {});
      await _storage.logout();
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Account Deleted', 'Your account has been deleted.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _storage.logout();
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
