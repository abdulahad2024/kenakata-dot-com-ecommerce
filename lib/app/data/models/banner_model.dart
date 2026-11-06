import '../../../../core/utils/image_helper.dart';

class BannerModel {
  final int id;
  final String? title;
  final String image;
  final String? link;

  BannerModel({
    required this.id,
    this.title,
    required this.image,
    this.link,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image']?.toString() ?? json['banner_url']?.toString();
    return BannerModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      title: json['title']?.toString(),
      image: ImageHelper.getImageUrl(rawImage),
      link: json['link']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'link': link,
    };
  }
}
