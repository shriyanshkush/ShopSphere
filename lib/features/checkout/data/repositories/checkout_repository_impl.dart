import 'package:shopsphere/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:shopsphere/features/checkout/data/models/address_model.dart';
import 'package:shopsphere/features/checkout/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remote;

  CheckoutRepositoryImpl(this.remote);

  @override
  Future<(List<AddressModel>, String?)> fetchAddresses() => remote.fetchAddresses();

  @override
  Future<(List<AddressModel>, String?)> addAddress({
    required String label,
    required String fullName,
    required String line1,
    required String city,
    required String state,
    required String zipCode,
    required String phone,
  }) {
    return remote.addAddress(
      label: label,
      fullName: fullName,
      line1: line1,
      city: city,
      state: state,
      zipCode: zipCode,
      phone: phone,
    );
  }

  @override
  Future<(List<AddressModel>, String?)> selectAddress(String id) => remote.selectAddress(id);

  @override
  Future<Map<String, dynamic>> fetchCart() => remote.fetchCart();

  @override
  Future<Map<String, dynamic>> placeOrder({
    required List<dynamic> cart,
    required double totalPrice,
    required String address,
    required Map<String, dynamic> payment,
  }) {
    return remote.placeOrder(
      cart: cart,
      totalPrice: totalPrice,
      address: address,
      payment: payment,
    );
  }
}
