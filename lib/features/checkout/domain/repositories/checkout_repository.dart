import 'package:shopsphere/features/checkout/data/models/address_model.dart';

abstract class CheckoutRepository {
  Future<(List<AddressModel>, String?)> fetchAddresses();
  Future<(List<AddressModel>, String?)> addAddress({
    required String label,
    required String fullName,
    required String line1,
    required String city,
    required String state,
    required String zipCode,
    required String phone,
  });
  Future<(List<AddressModel>, String?)> selectAddress(String id);
  Future<Map<String, dynamic>> fetchCart();
  Future<Map<String, dynamic>> placeOrder({
    required List<dynamic> cart,
    required double totalPrice,
    required String address,
    required Map<String, dynamic> payment,
  });
}
