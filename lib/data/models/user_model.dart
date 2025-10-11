class UserModel {
  final String id;
  final String role;
  final String name;
  final String email;
  final String? phone;
  final String? profilePicUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    this.phone,
    this.profilePicUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] as String?,
      profilePicUrl: json['profile_pic_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_pic_url': profilePicUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
