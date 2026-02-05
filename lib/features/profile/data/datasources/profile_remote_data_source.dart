import 'package:dio/dio.dart';
import 'package:shopsphere/core/services/api_service.dart';
import 'package:shopsphere/features/profile/data/models/recent_order_model.dart';

class ProfileRemoteDataSource {
  final Dio dio = ApiService().dio;

  Future<List<RecentOrderModel>> getRecentOrders() async {
    try {
      final res = await dio.get('/api/orders/recent');
      final items = (res.data['orders'] as List? ?? []);
      return items.map((e) => RecentOrderModel.fromJson(e)).toList();
    } catch (_) {
      return const [
        RecentOrderModel(
          id: '1',
          title: 'Sony WH-1000XM5 Wireless...',
          status: 'Arriving Tomorrow',
          image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
          canTrack: true,
        ),
        RecentOrderModel(
          id: '2',
          title: 'Minimalist Smart Watch Gen 6',
          status: 'Delivered Yesterday',
          image: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600',
          canReview: true,
        ),
        RecentOrderModel(
          id: '3',
          title: 'Nike Air Max Pro Running Shoes',
          status: 'Delivered Oct 12',
          image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
        ),
      ];
    }
  }
}
