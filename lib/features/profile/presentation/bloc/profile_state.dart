import 'package:shopsphere/features/profile/data/models/recent_order_model.dart';

class ProfileState {
  final bool loading;
  final List<RecentOrderModel> orders;

  const ProfileState({required this.loading, required this.orders});

  factory ProfileState.initial() => const ProfileState(loading: false, orders: []);

  ProfileState copyWith({bool? loading, List<RecentOrderModel>? orders}) {
    return ProfileState(loading: loading ?? this.loading, orders: orders ?? this.orders);
  }
}
