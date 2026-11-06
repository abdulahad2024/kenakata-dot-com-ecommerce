import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/order_model.dart';
import '../../../../core/constants/api_endpoints.dart';

class OrderController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  var isLoading = false.obs;
  var orders = <OrderModel>[].obs;
  var statusCounts = Rxn<OrderStatusCountsModel>();

  @override
  void onInit() {
    super.onInit();
    if (_storage.isLoggedIn) {
      fetchOrderData();
    }
  }

  Future<void> fetchOrderData() async {
    fetchOrders();
    fetchStatusCounts();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(ApiUrl.getOrderHistory);
      if (response is List) {
        orders.assignAll(response.map((e) => OrderModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        orders.assignAll((response['data'] as List).map((e) => OrderModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStatusCounts() async {
    try {
      final response = await _apiClient.get(ApiUrl.getOrderStatusCounts);
      if (response is Map<String, dynamic>) {
        statusCounts.value = OrderStatusCountsModel.fromJson(response);
      }
    } catch (_) {}
  }

  Future<void> cancelOrder(int orderId) async {
    try {
      await _apiClient.post(ApiUrl.cancelOrder(orderId), {});
      fetchOrderData();
      Get.snackbar('Order Cancelled', 'Order #$orderId has been cancelled',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
