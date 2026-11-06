import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../../core/constants/api_endpoints.dart';

class CategoryController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoadingCategories = true.obs;
  var isLoadingProducts = false.obs;

  var categories = <CategoryModel>[].obs;
  var categoryProducts = <ProductModel>[].obs;
  var selectedCategory = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
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

  Future<void> fetchCategoryProducts(int categoryId) async {
    try {
      isLoadingProducts.value = true;
      categoryProducts.clear();
      final response = await _apiClient.get(ApiUrl.getCategoryProducts(categoryId));
      if (response is List) {
        categoryProducts.assignAll(response.map((e) => ProductModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        categoryProducts.assignAll((response['data'] as List).map((e) => ProductModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
