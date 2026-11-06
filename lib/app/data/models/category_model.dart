import '../../../../core/utils/image_helper.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? image;
  final String? description;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image']?.toString() ?? json['icon']?.toString();
    return CategoryModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      name: json['name']?.toString() ?? 'ক্যাটাগরি',
      image: rawImage != null ? ImageHelper.getImageUrl(rawImage) : null,
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
    };
  }
}
