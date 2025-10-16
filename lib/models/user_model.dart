class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final List<AddressModel> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.addresses = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((address) => AddressModel.fromJson(address))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    List<AddressModel>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AddressModel {
  final String id;
  final String title;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? notes;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      title: json['title'],
      fullAddress: json['fullAddress'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      notes: json['notes'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'isDefault': isDefault,
    };
  }
}
