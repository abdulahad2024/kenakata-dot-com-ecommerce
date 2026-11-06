import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/product_model.dart';
import '../../../../core/constants/api_endpoints.dart';

class StoreController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var storeBanners = <BannerModel>[].obs;
  var storeProducts = <ProductModel>[].obs;

  Future<void> fetchStoreDetails(int sellerId) async {
    try {
      isLoading.value = true;
      fetchStoreBanners(sellerId);
      fetchStoreProducts(sellerId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStoreBanners(int sellerId) async {
    try {
      final response = await _apiClient.get(ApiUrl.getStoreSpecificBanners(sellerId));
      if (response is List) {
        storeBanners.assignAll(response.map((e) => BannerModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        storeBanners.assignAll((response['data'] as List).map((e) => BannerModel.fromJson(e)).toList());
      }
    } catch (_) {}
  }

  Future<void> fetchStoreProducts(int sellerId) async {
    try {
      final response = await _apiClient.get(ApiUrl.getStoreProducts(sellerId));
      if (response is List) {
        storeProducts.assignAll(response.map((e) => ProductModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        storeProducts.assignAll((response['data'] as List).map((e) => ProductModel.fromJson(e)).toList());
      }
    } catch (_) {}
  }
}
