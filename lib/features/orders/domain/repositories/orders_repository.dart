import '../../data/models/order_model.dart';

abstract class OrdersRepository {
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 20});

  Future<OrderModel> getOrderDetails(String orderId);
}
