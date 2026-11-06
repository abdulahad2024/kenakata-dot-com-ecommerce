class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? deliveryAddress;
  final String? image;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.deliveryAddress,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      deliveryAddress: json['delivery_address']?.toString() ?? json['address']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'delivery_address': deliveryAddress,
      'image': image,
    };
  }
}
