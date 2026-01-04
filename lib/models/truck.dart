class Truck {
  final int id;
  final String name;
  String imei;
  String? updatedAt;
  String? licenseExpDate;
  String? color;
  String? truckType;

  Truck({
    required this.id,
    required this.name,
    required this.imei,
    this.updatedAt,
    this.licenseExpDate,
    this.color,
    this.truckType,
  });

  factory Truck.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null || json['imei'] == null) {
      throw Exception("Missing required fields in Truck JSON: $json");
    }
    return Truck(
      id: json['id'] ?? 0,
      name: json['name'],
      imei: json['imei'],
      licenseExpDate: json['license_expiry_date'],
      color: json['color']?.toString(),
      truckType: json['truck_type'],
      updatedAt: json['updated_at'] ?? '1970/1/1',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'license_expiry_date': licenseExpDate,
    'imei': imei,
    'color': color,
    'truck_type': truckType,
    'updated_at': updatedAt,
  };
}
