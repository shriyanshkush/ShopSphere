import 'package:shopsphere/features/checkout/data/models/address_model.dart';

class CheckoutState {
  final bool loading;
  final List<AddressModel> addresses;
  final String? selectedAddressId;

  const CheckoutState({
    required this.loading,
    required this.addresses,
    required this.selectedAddressId,
  });

  factory CheckoutState.initial() => const CheckoutState(
        loading: false,
        addresses: [],
        selectedAddressId: null,
      );

  CheckoutState copyWith({
    bool? loading,
    List<AddressModel>? addresses,
    String? selectedAddressId,
  }) {
    return CheckoutState(
      loading: loading ?? this.loading,
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
    );
  }
}
