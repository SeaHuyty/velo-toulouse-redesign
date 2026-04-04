class UserModel {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String phoneNumber;
  final String password;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.imageUrl,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] as String,
      gender: data['gender'] as String,
      phoneNumber: data['phone_number'] as String,
      email: data['email'] as String,
      password: data['password'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'phone_number': phoneNumber,
      'image_url': imageUrl,
    };
  }
}
