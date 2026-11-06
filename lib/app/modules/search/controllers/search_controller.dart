import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/models/product_model.dart';
import '../../../../core/constants/api_endpoints.dart';

class SearchPageController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final searchTextController = TextEditingController();
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;

  final List<String> popularTags = [
    'স্মার্টফোন',
    'ফ্যাশন',
    'জুতো',
    'ঘড়ি',
    'হেডফোন',
    'অফার',
    'গ্যাজেট',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(ApiUrl.getAllProducts);
      if (response is List) {
        allProducts.assignAll(response.map((e) => ProductModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        allProducts.assignAll((response['data'] as List).map((e) => ProductModel.fromJson(e)).toList());
      }
      filterProducts(searchQuery.value);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    searchQuery.value = query.trim();
    if (searchQuery.value.isEmpty) {
      filteredProducts.clear();
      return;
    }

    final lowercaseQuery = searchQuery.value.toLowerCase();
    filteredProducts.assignAll(
      allProducts.where((p) {
        final title = p.title.toLowerCase();
        final desc = (p.description ?? '').toLowerCase();
        final seller = (p.sellerName ?? '').toLowerCase();
        final cat = (p.categoryName ?? '').toLowerCase();
        return title.contains(lowercaseQuery) ||
            desc.contains(lowercaseQuery) ||
            seller.contains(lowercaseQuery) ||
            cat.contains(lowercaseQuery);
      }).toList(),
    );
  }

  void onTagSelected(String tag) {
    searchTextController.text = tag;
    filterProducts(tag);
  }

  void clearSearch() {
    searchTextController.clear();
    filterProducts('');
  }
}
