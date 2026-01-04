class Category {
  final int id;
  final String name;
  final bool isHouseExpense;
  final String? description;
  String? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.isHouseExpense,
    this.description,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? 0;
    final name = json['name']?.toString() ?? 'Error';
    final isHouseExpense = json['isHouseExpense'];
    final description = json['description']?.toString();
    final updatedAt = json['updated_at'] ?? '1970/1/1';
    return Category(
      id: id,
      name: name,
      isHouseExpense: isHouseExpense,
      description: description,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isHouseExpense': isHouseExpense,
    'description': description,
    'updated_at': updatedAt,
  };
}
