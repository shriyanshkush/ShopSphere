import 'package:shopsphere/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:shopsphere/features/orders/data/models/order_details_model.dart';
import 'package:shopsphere/features/orders/data/models/order_summary_model.dart';
import 'package:shopsphere/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remote;

  OrdersRepositoryImpl(this._remote);

  @override
  Future<List<OrderSummaryModel>> fetchMyOrders() => _remote.fetchMyOrders();

  @override
  Future<OrderDetailsModel> fetchOrderDetails(String orderId) => _remote.fetchOrderDetails(orderId);
}
