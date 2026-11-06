import '../../../../core/utils/image_helper.dart';

class StoreModel {
  final int sellerId;
  final String storeName;
  final String? logo;
  final String? banner;
  final String? address;
  final double rating;

  StoreModel({
    required this.sellerId,
    required this.storeName,
    this.logo,
    this.banner,
    this.address,
    this.rating = 4.5,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final rawLogo = json['logo']?.toString() ??
        json['store_logo']?.toString() ??
        json['shop_logo']?.toString() ??
        json['image']?.toString() ??
        json['avatar']?.toString();

    final rawBanner = json['banner']?.toString() ??
        json['store_banner']?.toString() ??
        json['cover']?.toString() ??
        json['banner_url']?.toString();

    return StoreModel(
      sellerId: json['seller_id'] is int
          ? json['seller_id']
          : (json['id'] is int
              ? json['id']
              : (int.tryParse(json['seller_id']?.toString() ?? json['id']?.toString() ?? '0') ?? 0)),
      storeName: json['store_name']?.toString() ?? json['name']?.toString() ?? json['shop_name']?.toString() ?? 'অফিসিয়াল শপ',
      logo: rawLogo != null && rawLogo.isNotEmpty ? ImageHelper.getImageUrl(rawLogo) : null,
      banner: rawBanner != null && rawBanner.isNotEmpty ? ImageHelper.getImageUrl(rawBanner) : null,
      address: json['address']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seller_id': sellerId,
      'store_name': storeName,
      'logo': logo,
      'banner': banner,
      'address': address,
      'rating': rating,
    };
  }
}
