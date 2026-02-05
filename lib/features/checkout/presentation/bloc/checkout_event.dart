abstract class CheckoutEvent {}

class LoadAddresses extends CheckoutEvent {}

class SelectAddress extends CheckoutEvent {
  final String id;
  SelectAddress(this.id);
}

class AddAddress extends CheckoutEvent {
  final String label;
  final String fullName;
  final String line1;
  final String city;
  final String state;
  final String zipCode;
  final String phone;

  AddAddress({
    required this.label,
    required this.fullName,
    required this.line1,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
  });
}
