import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/review_model.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../../routes/app_routes.dart';

class ProductController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  var product = Rxn<ProductModel>();
  var reviews = <ReviewModel>[].obs;
  var isLoadingReviews = false.obs;
  var isSubmittingReview = false.obs;
  var isAddingToCart = false.obs;
  var isWishlisted = false.obs;

  var quantity = 1.obs;
  var selectedImageIndex = 0.obs;

  final reviewCommentController = TextEditingController();
  var newReviewRating = 5.0.obs;

  void setProduct(ProductModel prod) {
    product.value = prod;
    quantity.value = 1;
    selectedImageIndex.value = 0;
    isWishlisted.value = prod.isWishlisted;
    fetchReviews(prod.id);
  }

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  Future<void> fetchReviews(int productId) async {
    try {
      isLoadingReviews.value = true;
      final response = await _apiClient.get(ApiUrl.getProductReviews(productId));
      if (response is List) {
        reviews.assignAll(response.map((e) => ReviewModel.fromJson(e)).toList());
      } else if (response is Map && response['data'] is List) {
        reviews.assignAll((response['data'] as List).map((e) => ReviewModel.fromJson(e)).toList());
      }
    } catch (_) {
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> addToCart() async {
    if (!_storage.isLoggedIn) {
      await Get.toNamed(AppRoutes.login);
      if (!_storage.isLoggedIn) return; // User closed or canceled login
    }
    if (product.value == null) return;

    try {
      isAddingToCart.value = true;
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().addToCart(product.value!.id, quantity.value);
      } else {
        await _apiClient.post(ApiUrl.addToCart, {
          'product_id': product.value!.id,
          'quantity': quantity.value,
        });
        Get.snackbar('সফল', 'কার্টে যোগ করা হয়েছে!',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('ত্রুটি', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isAddingToCart.value = false;
    }
  }

  Future<void> toggleWishlist() async {
    if (!_storage.isLoggedIn) {
      await Get.toNamed(AppRoutes.login);
      if (!_storage.isLoggedIn) return;
    }
    if (product.value == null) return;

    // Toggle local reactive state instantly for quick feedback
    isWishlisted.value = !isWishlisted.value;

    if (Get.isRegistered<WishlistController>()) {
      Get.find<WishlistController>().toggleWishlist(product.value!.id);
    } else {
      try {
        await _apiClient.post(ApiUrl.toggleWishlist, {'product_id': product.value!.id});
        Get.snackbar(
          'উইশলিস্ট আপডেট',
          isWishlisted.value ? 'পছন্দের তালিকায় যুক্ত হয়েছে' : 'পছন্দের তালিকা থেকে সরানো হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.indigo,
          colorText: Colors.white,
        );
      } catch (e) {
        isWishlisted.value = !isWishlisted.value; // revert on error
        Get.snackbar('ত্রুটি', e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void shareProduct() {
    if (product.value == null) return;
    final shareText = '${product.value!.title}\nমূল্য: \$${product.value!.price.toStringAsFixed(2)}\nঅ্যাপ থেকে এখনই কিনুন!';
    Clipboard.setData(ClipboardData(text: shareText));
    Get.snackbar(
      'লিংক কপি করা হয়েছে! 📋',
      'প্রোডাক্টের লিংক আপনার ক্লিপবোর্ডে কপি হয়েছে। বন্ধুদের সাথে শেয়ার করুন।',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.indigo,
      colorText: Colors.white,
    );
  }

  Future<void> addReview() async {
    if (!_storage.isLoggedIn) {
      await Get.toNamed(AppRoutes.login);
      if (!_storage.isLoggedIn) return;
    }
    if (product.value == null || reviewCommentController.text.trim().isEmpty) {
      Get.snackbar('ভ্যালিডেশন', 'অনুগ্রহ করে রিভিউ কমেন্ট লিখুন।', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isSubmittingReview.value = true;
      await _apiClient.post(ApiUrl.addReview, {
        'product_id': product.value!.id,
        'rating': newReviewRating.value,
        'comment': reviewCommentController.text.trim(),
      });

      reviewCommentController.clear();
      Get.back();
      fetchReviews(product.value!.id);
      Get.snackbar('ধন্যবাদ!', 'আপনার রিভিউ জমা দেওয়া হয়েছে।',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('ত্রুটি', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmittingReview.value = false;
    }
  }
}
