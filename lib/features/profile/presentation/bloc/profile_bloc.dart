import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/profile/domain/repositories/profile_repository.dart';
import 'package:shopsphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:shopsphere/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repo;

  ProfileBloc(this.repo) : super(ProfileState.initial()) {
    on<LoadProfile>(_load);
  }

  Future<void> _load(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true));
    final orders = await repo.getRecentOrders();
    emit(state.copyWith(loading: false, orders: orders));
  }
}
