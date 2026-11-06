import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ionicons/ionicons.dart';
import '../controllers/product_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../theme/app_colors.dart';
import '../../../../core/widgets/custom_shimmer.dart';
import '../../../routes/app_routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductController>();
    final prod = Get.arguments as ProductModel;
    controller.setProduct(prod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('প্রোডাক্টের বিবরণ'),
        actions: [
          // Wishlist Button with Obx State
          Obx(
            () => IconButton(
              icon: Icon(
                Ionicons.heart,
                color: controller.isWishlisted.value ? AppColors.error : Colors.grey[400],
              ),
              onPressed: controller.toggleWishlist,
            ),
          ),
          // Share Button
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: controller.shareProduct,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Image Section
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Container(
                          color: Colors.grey[100],
                          child: product.image != null && product.image!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: product.image!,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const CustomShimmer(
                                    width: double.infinity,
                                    height: double.infinity,
                                    borderRadius: 0,
                                  ),
                                  errorWidget: (context, url, error) => CachedNetworkImage(
                                    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Icon(Ionicons.bag, size: 80, color: Colors.grey[400]),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Seller Info Tag
                            if (product.sellerName != null && product.sellerName!.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  if (product.sellerId != null) {
                                    Get.toNamed(AppRoutes.storeDetails, arguments: product);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Ionicons.storefront, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        product.sellerName!,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),

                            // Product Title
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Rating & Reviews Count Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withAlpha(40),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Ionicons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        product.rating.toStringAsFixed(1),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${controller.reviews.length} টি গ্রাহক রিভিউ',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Price Row
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (product.originalPrice != null && product.originalPrice! > product.price) ...[
                                  const SizedBox(width: 10),
                                  Text(
                                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),

                            const Divider(),
                            const SizedBox(height: 12),

                            // Description Section
                            const Text(
                              'পণ্যের বিবরণ',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description != null && product.description!.isNotEmpty
                                  ? product.description!
                                  : 'এই প্রোডাক্টের কোনো বিস্তারিত বিবরণ দেওয়া হয়নি।',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Reviews Preview Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'রিভিউ ও রেটিং',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                                  onPressed: () => _showAddReviewDialog(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            Obx(() {
                              if (controller.isLoadingReviews.value) {
                                return const CustomShimmer(width: double.infinity, height: 60, borderRadius: 12);
                              }
                              if (controller.reviews.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('কোনো রিভিউ নেই। আপনিই প্রথম রিভিউ দিন!',
                                      style: TextStyle(color: AppColors.textHint)),
                                );
                              }
                              final rev = controller.reviews.first;
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(rev.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            const Icon(Ionicons.star, color: Colors.amber, size: 14),
                                            const SizedBox(width: 2),
                                            Text('${rev.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(rev.comment, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Add To Cart Bar
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Quantity Stepper
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Ionicons.remove, size: 18),
                            onPressed: controller.decrementQuantity,
                          ),
                          Obx(() => Text(
                                '${controller.quantity.value}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                          IconButton(
                            icon: const Icon(Ionicons.add, size: 18),
                            onPressed: controller.incrementQuantity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Add To Cart Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Obx(
                          () => ElevatedButton.icon(
                            onPressed: controller.isAddingToCart.value ? null : controller.addToCart,
                            icon: controller.isAddingToCart.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Icon(Ionicons.cart),
                            label: Text(
                              controller.isAddingToCart.value ? 'যোগ করা হচ্ছে...' : 'কার্টে যোগ করুন',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('রিভিউ প্রদান করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              const Text('রেটিং বেছে নিন:'),
              const SizedBox(height: 8),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starRating = index + 1;
                      return IconButton(
                        icon: Icon(
                          Ionicons.star,
                          color: index < controller.newReviewRating.value ? Colors.amber : Colors.grey[300],
                          size: 32,
                        ),
                        onPressed: () => controller.newReviewRating.value = starRating.toDouble(),
                      );
                    }),
                  )),
              const SizedBox(height: 16),

              TextField(
                controller: controller.reviewCommentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'এই পণ্যটি সম্পর্কে আপনার মতামত লিখুন...',
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.addReview,
                  child: const Text('জমা দিন'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
