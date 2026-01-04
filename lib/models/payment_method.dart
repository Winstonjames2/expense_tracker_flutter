class PaymentMethod {
  final int id;
  final String name;
  final String? description;
  String? updatedAt;

  PaymentMethod({
    required this.id,
    required this.name,
    this.description,
    this.updatedAt,
  });
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? 0;
    final name = json['name'] ?? 'Unknown';
    final description = json['description'] ?? '';
    final updatedAt = json['updated_at'] ?? '1970/1/1';
    return PaymentMethod(
      id: id,
      name: name,
      description: description,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'updated_at': updatedAt,
  };
}
