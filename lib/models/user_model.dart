class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String uniqueId;
  final bool isApproved;
  final String? subscriptionStatus;
  final DateTime? subscriptionExpiryDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.uniqueId,
    required this.isApproved,
    this.subscriptionStatus,
    this.subscriptionExpiryDate,
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
      subscriptionStatus: json['subscriptionStatus'],
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'])
          : null,
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
      'subscriptionStatus': subscriptionStatus,
      'subscriptionExpiryDate': subscriptionExpiryDate?.toIso8601String(),
    };
  }
}