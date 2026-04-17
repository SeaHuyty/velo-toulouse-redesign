class UserModel {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String phoneNumber;
  final String? password;
  final String imageUrl;
  final String? activePassId;
  final String? activePassTitle;
  final String? activePassExpiry;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    this.password,
    required this.imageUrl,
    this.activePassId,
    this.activePassTitle,
    this.activePassExpiry,
  });

  UserModel copyWith({
    String? name,
    String? gender,
    String? phoneNumber,
    String? imageUrl,
    String? activePassId,
    String? activePassTitle,
    String? activePassExpiry,
    bool clearActivePass = false,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      activePassId: clearActivePass ? null : (activePassId ?? this.activePassId),
      activePassTitle: clearActivePass ? null : (activePassTitle ?? this.activePassTitle),
      activePassExpiry: clearActivePass ? null : (activePassExpiry ?? this.activePassExpiry),
    );
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] as String,
      gender: data['gender'] as String,
      phoneNumber: data['phone_number'] as String,
      email: data['email'] as String,
      imageUrl: data['image_url'] as String? ?? '',
      activePassId: data['active_pass_id'] as String?,
      activePassTitle: data['active_pass_title'] as String?,
      activePassExpiry: data['active_pass_expiry'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'phone_number': phoneNumber,
      'image_url': imageUrl,
      'active_pass_id': activePassId,
      'active_pass_title': activePassTitle,
      'active_pass_expiry': activePassExpiry,
    };
  }
}
