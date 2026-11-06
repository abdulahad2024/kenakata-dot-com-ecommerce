import 'package:get/get.dart';
import 'app_routes.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_screen.dart';

import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_screen.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/register_screen.dart';
import '../modules/auth/views/change_password_screen.dart';

import '../modules/main_nav/bindings/main_nav_binding.dart';
import '../modules/main_nav/views/main_nav_screen.dart';

import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_screen.dart';

import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/categories_screen.dart';
import '../modules/category/views/category_products_screen.dart';

import '../modules/store/bindings/store_binding.dart';
import '../modules/store/views/store_details_screen.dart';

import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_details_screen.dart';
import '../modules/product/views/low_price_products_screen.dart';
import '../modules/product/views/all_products_screen.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_screen.dart';
import '../modules/cart/views/checkout_screen.dart';

import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_screen.dart';

import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_history_screen.dart';

import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_screen.dart';
import '../modules/profile/views/edit_profile_screen.dart';
import '../modules/profile/views/delivery_address_screen.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.mainNav,
      page: () => const MainNavScreen(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.categoryProducts,
      page: () => const CategoryProductsScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.storeDetails,
      page: () => const StoreDetailsScreen(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.lowPriceProducts,
      page: () => const LowPriceProductsScreen(),
    ),
    GetPage(
      name: AppRoutes.allProducts,
      page: () => const AllProductsScreen(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistScreen(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.deliveryAddress,
      page: () => const DeliveryAddressScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
