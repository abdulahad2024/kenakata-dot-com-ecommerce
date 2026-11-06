import 'package:get/get.dart';
import '../controllers/main_nav_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<WishlistController>(() => WishlistController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
