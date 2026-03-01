import 'package:dio/dio.dart';
import 'package:shopsphere/core/services/api_service.dart';

import '../models/order_model.dart';

class OrdersRemoteDataSource {
  final Dio dio = ApiService().dio;

  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 20}) async {
    final response = await dio.get(
      '/api/orders/me',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final orders = response.data['orders'] as List<dynamic>? ?? const [];
    return orders
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OrderModel> getOrderDetails(String orderId) async {
    final response = await dio.get('/api/orders/$orderId');
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }
}