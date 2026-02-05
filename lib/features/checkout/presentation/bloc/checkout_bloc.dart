import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/checkout/domain/repositories/checkout_repository.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository repo;

  CheckoutBloc(this.repo) : super(CheckoutState.initial()) {
    on<LoadAddresses>(_load);
    on<SelectAddress>(_select);
    on<AddAddress>(_add);
  }

  Future<void> _load(LoadAddresses event, Emitter<CheckoutState> emit) async {
    emit(state.copyWith(loading: true));
    final res = await repo.fetchAddresses();
    emit(state.copyWith(
      loading: false,
      addresses: res.$1,
      selectedAddressId: res.$2,
    ));
  }

  Future<void> _select(SelectAddress event, Emitter<CheckoutState> emit) async {
    final res = await repo.selectAddress(event.id);
    emit(state.copyWith(
      addresses: res.$1,
      selectedAddressId: res.$2,
    ));
  }

  Future<void> _add(AddAddress event, Emitter<CheckoutState> emit) async {
    final res = await repo.addAddress(
      label: event.label,
      fullName: event.fullName,
      line1: event.line1,
      city: event.city,
      state: event.state,
      zipCode: event.zipCode,
      phone: event.phone,
    );

    emit(state.copyWith(
      addresses: res.$1,
      selectedAddressId: res.$2,
    ));
  }
}
