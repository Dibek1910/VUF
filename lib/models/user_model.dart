class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String uniqueId;
  final String? subscriptionStatus;
  final DateTime? subscriptionExpiryDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.uniqueId,
    this.subscriptionStatus,
    this.subscriptionExpiryDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      uniqueId: json['unique_id'] ?? '',
      subscriptionStatus: json['subscription_status'],
      subscriptionExpiryDate: json['subscription_expiry_date'] != null
          ? DateTime.parse(json['subscription_expiry_date'])
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
      'unique_id': uniqueId,
      'subscription_status': subscriptionStatus,
      'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
    };
  }
}
