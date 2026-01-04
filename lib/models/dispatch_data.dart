class DispatchData {
  final int id;
  DateTime? dispatchingDate;
  Map<String, dynamic> truck;
  String? driver;
  final double? totalCost;
  final double? totalRevenue;
  bool isActive;

  DispatchData({
    required this.id,
    required this.truck,
    this.dispatchingDate,
    this.driver,
    this.totalCost,
    this.totalRevenue,
    this.isActive = false,
  });

  DispatchData copyWith({
    int? id,
    bool? isActive,
    DateTime? dispatchingDate,
    Map<String, dynamic>? truck,
    String? driver,
    double? totalCost,
    double? totalRevenue,
  }) {
    return DispatchData(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      dispatchingDate: dispatchingDate ?? this.dispatchingDate,
      truck: truck ?? this.truck,
      driver: driver ?? this.driver,
      totalCost: totalCost ?? this.totalCost,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }

  factory DispatchData.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final truck =
        json['truck'] != null && json['truck'] is Map
            ? Map<String, dynamic>.from(json['truck'] as Map)
            : {};
    final dispatchingDate =
        json['dispatch_date'] != null
            ? DateTime.parse(json['dispatch_date'])
            : null;
    final driver = json['driver_name'] as String?;
    final totalCost = json['total_cost'];
    final totalRevenue = json['total_revenue'];
    final isActive = json['is_active'] ?? false;
    return DispatchData(
      truck: truck.cast<String, dynamic>(),
      id: id,
      dispatchingDate: dispatchingDate,
      driver: driver,
      totalCost: totalCost,
      totalRevenue: totalRevenue,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'truck': truck,
    'id': id,
    'dispatch_date': dispatchingDate?.toIso8601String(),
    'driver_name': driver,
    'total_cost': totalCost,
    'total_revenue': totalRevenue,
    'is_active': isActive,
  };
}
