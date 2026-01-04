class Account {
  final int id;
  final String name;
  final double balance;
  final String? currency;
  final String? type;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
    required this.type,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'type': type,
    };
  }
}
