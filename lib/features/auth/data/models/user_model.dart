class UserModel {
  final String id;
  final String fullName;
  final String email;
  final bool isVerified;

  UserModel({required this.id, required this.fullName, required this.email, required this.isVerified});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      isVerified: json['isVerified'] ?? false,
    );
  }
}