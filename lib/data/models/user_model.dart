class UserModel {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String phoneNumber;
  final String? password;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    this.password,
    required this.imageUrl,
  });

  UserModel copyWith({
    String? name,
    String? gender,
    String? phoneNumber,
    String? imageUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
