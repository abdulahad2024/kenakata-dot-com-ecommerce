import 'app_config.dart';

class ApiUrl {
  static String get baseUrl => '${AppConfig.appBaseUrl}/api/';

  // Products & Stores
  static String get getAllProducts => '${baseUrl}products/all';
  static String get getLowPriceProducts => '${baseUrl}products/low-price';
  static String getStoreProducts(int sellerId) => '${baseUrl}store/products?seller_id=$sellerId';

  // Categories
  static String get getUserCategories => '${baseUrl}user/categories';
  static String getCategoryProducts(int categoryId) => '${baseUrl}user/categories/$categoryId/products';

  // Stores & Banners
  static String get getAllActiveStores => '${baseUrl}user/stores';
  static String get getLatestHomeBanners => '${baseUrl}user/banners/latest';
  static String getStoreSpecificBanners(int sellerId) => '${baseUrl}user/banners/store/$sellerId';

  // Auth & Profile
  static String get register => '${baseUrl}register';
  static String get login => '${baseUrl}login';
  static String get profile => '${baseUrl}profile';
  static String get updateProfile => '${baseUrl}profile/update';
  static String get deleteAccount => '${baseUrl}delete-account';
  static String get updateDeliveryAddress => '${baseUrl}user/update-delivery-address';
  static String get changePassword => '${baseUrl}change-password';

  // Wishlist
  static String get toggleWishlist => '${baseUrl}wishlist/toggle';
  static String get getWishlist => '${baseUrl}wishlist';

  // Cart
  static String get getCart => '${baseUrl}cart';
  static String get addToCart => '${baseUrl}cart/add';
  static String get updateCartQuantity => '${baseUrl}cart/update-quantity';
  static String removeCartItem(int cartId) => '${baseUrl}cart/remove/$cartId';

  // Orders
  static String get storeOrder => '${baseUrl}order/store';
  static String get getOrderHistory => '${baseUrl}order/history';
  static String cancelOrder(int orderId) => '${baseUrl}order/cancel/$orderId';

  // Reviews
  static String getProductReviews(int productId) => '${baseUrl}products/$productId/reviews';
  static String get addReview => '${baseUrl}reviews';
  static String updateReview(int reviewId) => '${baseUrl}reviews/$reviewId';
  static String deleteReview(int reviewId) => '${baseUrl}reviews/$reviewId';

  // Dashboard / Order Status
  static String get getOrderStatusCounts => '${baseUrl}order/status-counts';
}
