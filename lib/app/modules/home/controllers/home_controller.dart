import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/store_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../../core/constants/api_endpoints.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoadingBanners = true.obs;
  var isLoadingCategories = true.obs;
  var isLoadingStores = true.obs;
  var isLoadingLowPrice = true.obs;
  var isLoadingAllProducts = true.obs;

  var banners = <BannerModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var activeStores = <StoreModel>[].obs;
  var lowPriceProducts = <ProductModel>[].obs;
  var allProducts = <ProductModel>[].obs;

  var currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    fetchBanners();
    fetchCategories();
    fetchActiveStores();
    fetchLowPriceProducts();
    fetchAllProducts();
  }

  Future<void> fetchBanners() async {
    try {
      isLoadingBanners.value = true;
      final response = await _apiClient.get(ApiUrl.getLatestHomeBanners);
      if (response is List) {
        banners.assignAll(response.map((e) => BannerModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        banners.assignAll((response['data'] as List).map((e) => BannerModel.fromJson(e)).toList());
      }
    } catch (_) {
      // Fallback dummy banner if server empty
      banners.assignAll([
        BannerModel(id: 1, image: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800', title: 'Special Offers 50% Off'),
        BannerModel(id: 2, image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800', title: 'Top Brands Collection'),
      ]);
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final response = await _apiClient.get(ApiUrl.getUserCategories);
      if (response is List) {
        categories.assignAll(response.map((e) => CategoryModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        categories.assignAll((response['data'] as List).map((e) => CategoryModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchActiveStores() async {
    try {
      isLoadingStores.value = true;
      final response = await _apiClient.get(ApiUrl.getAllActiveStores);
      if (response is List) {
        activeStores.assignAll(response.map((e) => StoreModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        activeStores.assignAll((response['data'] as List).map((e) => StoreModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> fetchLowPriceProducts() async {
    try {
      isLoadingLowPrice.value = true;
      final response = await _apiClient.get(ApiUrl.getLowPriceProducts);
      if (response is List) {
        lowPriceProducts.assignAll(response.map((e) => ProductModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        lowPriceProducts.assignAll((response['data'] as List).map((e) => ProductModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoadingLowPrice.value = false;
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoadingAllProducts.value = true;
      final response = await _apiClient.get(ApiUrl.getAllProducts);
      if (response is List) {
        allProducts.assignAll(response.map((e) => ProductModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        allProducts.assignAll((response['data'] as List).map((e) => ProductModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoadingAllProducts.value = false;
    }
  }
}
