class AdminOrderModel {
  final String id;
  final String status;
  final double amount;


  AdminOrderModel({
    required this.id,
    required this.status,
    required this.amount,
  });


  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderModel(
      id: json['_id'],
      status: json['status'].toString(),
      amount: json['totalPrice'].toDouble(),
    );
  }
}