import 'dart:convert';
import '../../../../core/utils/image_helper.dart';

class ProductModel {
  final int id;
  final String title;
  final String? description;
  final double price;
  final double? originalPrice;
  final int? sellerId;
  final String? sellerName;
  final int? categoryId;
  final String? categoryName;
  final String? image;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isWishlisted;

  ProductModel({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.originalPrice,
    this.sellerId,
    this.sellerName,
    this.categoryId,
    this.categoryName,
    this.image,
    this.images = const [],
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isWishlisted = false,
  });

  static double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0.0;

  static bool _isValid(dynamic v) {
    if (v == null) return false;
    final s = v.toString().trim();
    return s.isNotEmpty && s != 'null';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // ---------- ছবি ----------
    // গ্যালারি: API-তে 'multiple_images' নামে আসে
    final List<String> gallery = [];
    dynamic rawList = json['multiple_images'] ??
        json['images'] ??
        json['photos'] ??
        json['product_images'];
    if (rawList is String && rawList.trim().startsWith('[')) {
      try {
        rawList = jsonDecode(rawList);
      } catch (_) {}
    }
    if (rawList is List) {
      for (final item in rawList) {
        if (_isValid(item)) gallery.add(ImageHelper.getImageUrl(item.toString()));
      }
    }

    // মূল ছবি: API-তে 'main_image' নামে আসে
    final dynamic singleImg = json['main_image'] ??
        json['image'] ??
        json['product_image'] ??
        json['photo'] ??
        json['thumbnail'] ??
        json['img'] ??
        json['featured_image'] ??
        json['image_url'] ??
        json['cover'] ??
        json['avatar'];

    final bool hasMain = _isValid(singleImg);
    final String? mainImage =
    hasMain ? ImageHelper.getImageUrl(singleImg.toString()) : null;

    final String displayImage = mainImage ??
        (gallery.isNotEmpty ? gallery.first : ImageHelper.getImageUrl(null));

    final List<String> allImages = [
      ?mainImage,
      ...gallery.where((e) => e != mainImage),
    ];

    // ---------- দাম ----------
    // regular_price = আসল দাম, discount_price = বিক্রির দাম
    final double regular = _toDouble(json['regular_price']);
    final double discount = _toDouble(json['discount_price']);
    final double basePrice = _toDouble(json['price'] ?? json['unit_price']);

    final double sellingPrice =
    discount > 0 ? discount : (regular > 0 ? regular : basePrice);

    double oldPrice = regular;
    if (oldPrice <= sellingPrice) {
      oldPrice = _toDouble(
          json['original_price'] ?? json['old_price'] ?? json['mrp']);
    }

    return ProductModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      title: json['title']?.toString() ??
          json['name']?.toString() ??
          json['product_name']?.toString() ??
          'প্রোডাক্ট',
      description:
      json['description']?.toString() ?? json['details']?.toString(),
      price: sellingPrice,
      originalPrice: oldPrice > sellingPrice ? oldPrice : null,
      sellerId: json['seller_id'] is int
          ? json['seller_id']
          : int.tryParse(json['seller_id']?.toString() ?? ''),
      sellerName: json['seller_name']?.toString() ??
          json['store_name']?.toString() ??
          json['shop_name']?.toString(),
      // API-তে ফিল্ডের নাম 'categories_id'
      categoryId: int.tryParse(
          (json['categories_id'] ?? json['category_id'])?.toString() ?? ''),
      categoryName: json['category_name']?.toString(),
      image: displayImage,
      images: allImages.isNotEmpty ? allImages : [displayImage],
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      reviewCount: int.tryParse(json['reviews_count']?.toString() ??
          json['review_count']?.toString() ??
          '0') ??
          0,
      isWishlisted:
      json['is_wishlisted'] == true || json['is_favorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'category_id': categoryId,
      'category_name': categoryName,
      'image': image,
      'images': images,
      'rating': rating,
      'reviews_count': reviewCount,
      'is_wishlisted': isWishlisted,
    };
  }
}