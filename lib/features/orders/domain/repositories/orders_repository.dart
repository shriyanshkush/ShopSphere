import 'package:shopsphere/features/orders/data/models/order_details_model.dart';
import 'package:shopsphere/features/orders/data/models/order_summary_model.dart';

abstract class OrdersRepository {
  Future<List<OrderSummaryModel>> fetchMyOrders();
  Future<OrderDetailsModel> fetchOrderDetails(String orderId);
}
