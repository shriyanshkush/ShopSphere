import 'package:shopsphere/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:shopsphere/features/profile/data/models/recent_order_model.dart';
import 'package:shopsphere/features/profile/domain/repositories/profile_repository.dart';

import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<List<RecentOrderModel>> getRecentOrders() {
    return remote.getRecentOrders();
  }

  @override
  Future<UserModel?> getProfile() {
    return remote.getProfile();
  }
}
