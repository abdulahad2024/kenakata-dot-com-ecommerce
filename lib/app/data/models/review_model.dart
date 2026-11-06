import '../../../../core/utils/image_helper.dart';

class ReviewModel {
  final int id;
  final int productId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final rawAvatar = json['user_avatar']?.toString() ?? json['user']?['avatar']?.toString();

    return ReviewModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      productId: json['product_id'] is int ? json['product_id'] : (int.tryParse(json['product_id']?.toString() ?? '0') ?? 0),
      userName: json['user_name']?.toString() ?? json['user']?['name']?.toString() ?? 'Customer',
      userAvatar: rawAvatar != null ? ImageHelper.getImageUrl(rawAvatar) : null,
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      comment: json['comment']?.toString() ?? json['review']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? 'Recently',
    );
  }
}
