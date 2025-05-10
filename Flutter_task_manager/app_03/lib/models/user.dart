class User {
  String id;
  String username;
  String password;
  String email;
  String? avatar; // Thêm thuộc tính này
  DateTime createdAt;
  DateTime lastActive;
  bool isAdmin;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    this.avatar, // Đảm bảo tham số này có mặt
    required this.createdAt,
    required this.lastActive,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] != null ? json['avatar'] as String : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastActive: DateTime.parse(json['lastActive'] ?? DateTime.now().toIso8601String()),
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'avatar': avatar, // Đảm bảo tham số này có mặt
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isAdmin': isAdmin,
    };
  }
}