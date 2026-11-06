import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ionicons/ionicons.dart';
import '../../app/data/models/product_model.dart';
import '../../app/theme/app_colors.dart';
import 'custom_shimmer.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onWishlistToggle;
  final VoidCallback? onAddToCart;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onWishlistToggle,
    this.onAddToCart,
    this.isWishlisted = false,
  });

  /// ইংরেজি সংখ্যাকে বাংলা সংখ্যায় রূপান্তর: 70 -> ৭০
  static String _bn(String input) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';
    return input.split('').map((c) {
      final i = en.indexOf(c);
      return i == -1 ? c : bn[i];
    }).join();
  }

  /// 70000 -> ৳৭০,০০০
  static String _taka(double value) {
    final s = value.round().toString();
    final withCommas = s.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]},',
    );
    return '৳${_bn(withCommas)}';
  }

  int get _discountPercent {
    final old = product.originalPrice;
    if (old == null || old <= product.price || old <= 0) return 0;
    return ((1 - product.price / old) * 100).round();
  }

  Widget _imagePlaceholder() => Container(
    color: Colors.grey[100],
    alignment: Alignment.center,
    child: Icon(Ionicons.imageOutline, color: Colors.grey[400], size: 36),
  );

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent;
    final showRating = product.reviewCount > 0 && product.rating > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(14),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- ছবি ----------
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: product.image != null && product.image!.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: product.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const CustomShimmer(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 0,
                      ),
                      errorWidget: (context, url, error) =>
                          _imagePlaceholder(),
                    )
                        : _imagePlaceholder(),
                  ),
                ),

                // ডিসকাউন্ট ব্যাজ
                if (discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${_bn(discount.toString())}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // উইশলিস্ট বাটন
                if (onWishlistToggle != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onWishlistToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          isWishlisted
                              ? Ionicons.heart
                              : Ionicons.headsetOutline,
                          color:
                          isWishlisted ? AppColors.error : Colors.grey[500],
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                // রেটিং ব্যাজ (শুধু রিভিউ থাকলে)
                if (showRating)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Ionicons.star,
                              color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            _bn(product.rating.toStringAsFixed(1)),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // ---------- লেখা ও দাম ----------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (discount > 0)
                                Text(
                                  _taka(product.originalPrice!),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 10.5,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              Text(
                                _taka(product.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: onAddToCart ?? onTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.lerp(
                                      AppColors.primary, Colors.white, 0.25)!,
                                  AppColors.primary,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Ionicons.cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}