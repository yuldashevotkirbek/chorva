class AdminModel {
  final String id;
  final String email;
  final String name;
  final String role; // admin, super_admin
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLogin;
  final List<String> permissions;

  AdminModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    required this.lastLogin,
    this.permissions = const [],
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'permissions': permissions,
    };
  }

  bool get isSuperAdmin => role == 'super_admin';
  bool get canManageUsers => permissions.contains('manage_users') || isSuperAdmin;
  bool get canManageProducts => permissions.contains('manage_products') || isSuperAdmin;
  bool get canManageOrders => permissions.contains('manage_orders') || isSuperAdmin;
  bool get canViewAnalytics => permissions.contains('view_analytics') || isSuperAdmin;
}
