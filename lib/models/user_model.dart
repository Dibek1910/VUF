class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String uniqueId;
  final bool isApproved;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.uniqueId,
    required this.isApproved,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? '',
      uniqueId: json['uniqueId'] ?? '',
      isApproved: json['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'uniqueId': uniqueId,
      'isApproved': isApproved,
    };
  }
}
