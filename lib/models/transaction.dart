class Transaction {
  final int id;
  DateTime date;
  String description;
  double amount;
  int category;
  String transactionType;
  int? paymentMethod;
  Map<String, dynamic>? truckDispatching;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.transactionType,
    required this.date,
    this.paymentMethod,
    this.truckDispatching,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'] ?? '',
      amount: double.parse(json['amount'].toString()),
      category: json['category'],
      transactionType: json['transaction_type'],
      paymentMethod: json['payment_method'],
      date: DateTime.parse(json['date']),
      truckDispatching: json['truck_dispatching'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      'transaction_type': transactionType,
      'payment_method': paymentMethod,
      'date': date.toIso8601String(),
      'truck_dispatching': truckDispatching,
    };
  }
}
