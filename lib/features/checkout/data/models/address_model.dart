class AddressModel {
  final String id;
  final String label;
  final String fullName;
  final String line1;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.line1,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.isDefault,
  });

  String get fullAddress => [line1, city, state, zipCode].where((e) => e.isNotEmpty).join(', ');

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Home',
      fullName: json['fullName']?.toString() ?? '',
      line1: json['line1']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipCode: json['zipCode']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      isDefault: json['isDefault'] == true,
    );
  }
}
