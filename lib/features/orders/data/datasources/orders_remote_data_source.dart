import 'package:dio/dio.dart';
import 'package:shopsphere/core/services/api_service.dart';
import 'package:shopsphere/features/orders/data/models/order_details_model.dart';
import 'package:shopsphere/features/orders/data/models/order_summary_model.dart';

class OrdersRemoteDataSource {
  final Dio dio = ApiService().dio;

  Future<List<OrderSummaryModel>> fetchMyOrders() async {
    final res = await dio.get('/api/orders/me', queryParameters: {'limit': 100});
    final items = (res.data['orders'] as List? ?? []);
    return items
        .map((e) => OrderSummaryModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<OrderDetailsModel> fetchOrderDetails(String orderId) async {
    final res = await dio.get('/api/orders/$orderId');
    return OrderDetailsModel.fromJson((res.data as Map).cast<String, dynamic>());
  }
}
