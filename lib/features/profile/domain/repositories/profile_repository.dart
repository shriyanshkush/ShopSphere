import 'package:shopsphere/features/profile/data/models/recent_order_model.dart';

import '../../data/models/user_model.dart';

abstract class ProfileRepository {
  Future<List<RecentOrderModel>> getRecentOrders();
  Future<UserModel?> getProfile();
}
