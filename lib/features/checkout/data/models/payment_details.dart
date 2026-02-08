class PaymentDetails {
  final String method;
  final String status;
  final String provider;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final double amount;
  final String currency;
  final DateTime? paidAt;

  const PaymentDetails({
    required this.method,
    required this.status,
    required this.provider,
    required this.amount,
    this.currency = 'INR',
    this.paymentId,
    this.orderId,
    this.signature,
    this.paidAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
      'provider': provider,
      'paymentId': paymentId,
      'orderId': orderId,
      'signature': signature,
      'amount': amount,
      'currency': currency,
      if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
    };
  }
}
