import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 20}) {
    return remoteDataSource.getMyOrders(page: page, limit: limit);
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) {
    return remoteDataSource.getOrderDetails(orderId);
  }
}