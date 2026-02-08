import 'package:shopsphere/features/checkout/data/models/address_model.dart';
import 'package:shopsphere/features/checkout/data/models/payment_details.dart';

class CheckoutPaymentArgs {
  final AddressModel address;

  const CheckoutPaymentArgs({required this.address});
}

class CheckoutReviewArgs {
  final AddressModel address;
  final PaymentDetails payment;

  const CheckoutReviewArgs({required this.address, required this.payment});
}
