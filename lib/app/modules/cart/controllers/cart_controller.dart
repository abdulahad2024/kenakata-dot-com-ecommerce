import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/cart_model.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../order/controllers/order_controller.dart';
import '../../../routes/app_routes.dart';

class CartController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  var isLoading = false.obs;
  var cart = Rxn<CartModel>();

  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (_storage.isLoggedIn) {
      fetchCart();
      _prefillData();
    }
  }

  void _prefillData() {
    if (_storage.user != null) {
      final userMap = _storage.user!;
      final addr = userMap['delivery_address']?.toString() ??
          userMap['address']?.toString() ??
          '';
      final phone = userMap['phone']?.toString() ??
          userMap['phone_number']?.toString() ??
          userMap['mobile']?.toString() ??
          '';

      if (addr.isNotEmpty && addressController.text.isEmpty) {
        addressController.text = addr;
      }
      if (phone.isNotEmpty && phoneController.text.isEmpty) {
        phoneController.text = phone;
      }
    }
  }

  Future<void> fetchCart() async {
    if (!_storage.isLoggedIn) return;

    try {
      isLoading.value = true;
      final response = await _apiClient.get(ApiUrl.getCart);
      cart.value = CartModel.fromJson(response);
    } catch (_) {
      cart.value = CartModel(items: [], subtotal: 0, grandTotal: 0);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    if (!_storage.isLoggedIn) {
      await Get.toNamed(AppRoutes.login);
      if (!_storage.isLoggedIn) return;
    }

    try {
      await _apiClient.post(ApiUrl.addToCart, {
        'product_id': productId,
        'quantity': quantity,
      });
      fetchCart();
      Get.snackbar('সফল', 'প্রোডাক্ট কার্টে যোগ করা হয়েছে!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('ত্রুটি', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateQuantity(int cartId, int quantity) async {
    try {
      await _apiClient.post(ApiUrl.updateCartQuantity, {
        'cart_id': cartId,
        'quantity': quantity,
      });
      fetchCart();
    } catch (e) {
      Get.snackbar('ত্রুটি', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> removeCartItem(int cartId) async {
    try {
      await _apiClient.delete(ApiUrl.removeCartItem(cartId));
      fetchCart();
      Get.snackbar('কার্ট আপডেট', 'আইটিম কার্ট থেকে সরানো হয়েছে',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('ত্রুটি', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> checkoutOrder() async {
    final addressText = addressController.text.trim();
    final phoneText = phoneController.text.trim();

    if (phoneText.isEmpty) {
      Get.snackbar('ভ্যালিডেশন', 'অনুগ্রহ করে আপনার ফোন নম্বর লিখুন।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (addressText.isEmpty) {
      Get.snackbar('ভ্যালিডেশন', 'অনুগ্রহ করে ডেলিভারি ঠিকানা লিখুন।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // 1. First sync phone number & delivery address to user's backend DB record
      try {
        final userName = _storage.user?['name']?.toString() ?? 'গ্রাহক';
        await _apiClient.post(ApiUrl.updateProfile, {
          'name': userName,
          'phone': phoneText,
          'mobile': phoneText,
        });
      } catch (_) {}

      try {
        await _apiClient.post(ApiUrl.updateDeliveryAddress, {
          'delivery_address': addressText,
          'address': addressText,
        });
      } catch (_) {}

      // 2. Place Order
      await _apiClient.post(ApiUrl.storeOrder, {
        'delivery_address': addressText,
        'address': addressText,
        'phone': phoneText,
        'mobile': phoneText,
        'phone_number': phoneText,
        'payment_method': 'cod',
      });

      // Update local storage user record
      if (_storage.user != null) {
        final updatedUser = Map<String, dynamic>.from(_storage.user!);
        updatedUser['phone'] = phoneText;
        updatedUser['delivery_address'] = addressText;
        await _storage.saveUser(updatedUser);
      }

      // Clear Cart state locally & refresh OrderController
      cart.value = CartModel(items: [], subtotal: 0, grandTotal: 0);
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().fetchOrderData();
      }

      Get.offNamedUntil(AppRoutes.mainNav, (route) => false);
      Get.snackbar('অর্ডার সফল! 🎉', 'আপনার অর্ডারটি সফলভাবে গ্রহণ করা হয়েছে।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('চেকআউট এরর', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
