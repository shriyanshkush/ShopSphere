import 'package:dio/dio.dart';
import 'package:shopsphere/core/services/api_service.dart';
import 'package:shopsphere/features/checkout/data/models/address_model.dart';

class CheckoutRemoteDataSource {
  final Dio dio = ApiService().dio;

  Future<(List<AddressModel>, String?)> fetchAddresses() async {
    final res = await dio.get('/api/user/addresses');
    final addresses = ((res.data['addresses'] as List?) ?? [])
        .map((e) => AddressModel.fromJson(e))
        .toList();
    return (addresses, res.data['selectedAddressId']?.toString());
  }

  Future<(List<AddressModel>, String?)> addAddress({
    required String label,
    required String fullName,
    required String line1,
    required String city,
    required String state,
    required String zipCode,
    required String phone,
  }) async {
    final res = await dio.post('/api/user/addresses', data: {
      'label': label,
      'fullName': fullName,
      'line1': line1,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phone': phone,
    });

    final addresses = ((res.data['addresses'] as List?) ?? [])
        .map((e) => AddressModel.fromJson(e))
        .toList();
    return (addresses, res.data['selectedAddressId']?.toString());
  }

  Future<(List<AddressModel>, String?)> selectAddress(String id) async {
    final res = await dio.patch('/api/user/addresses/$id/select');
    final addresses = ((res.data['addresses'] as List?) ?? [])
        .map((e) => AddressModel.fromJson(e))
        .toList();
    return (addresses, res.data['selectedAddressId']?.toString());
  }
}
