import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:shopsphere/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:shopsphere/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:shopsphere/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:shopsphere/features/checkout/presentation/bloc/checkout_state.dart';

class CheckoutAddressPage extends StatelessWidget {
  const CheckoutAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutBloc(CheckoutRepositoryImpl(CheckoutRemoteDataSource()))..add(LoadAddresses()),
      child: const _CheckoutAddressView(),
    );
  }
}

class _CheckoutAddressView extends StatelessWidget {
  const _CheckoutAddressView();

class CheckoutAddressPage extends StatefulWidget {
  const CheckoutAddressPage({super.key});

  @override
  State<CheckoutAddressPage> createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  int selected = 0;

  final addresses = const [
    ('Jane Doe (Home)', '123 Maple St, Springfield, IL, 62704', '+1 (555) 012-3456'),
    ('Jane Doe (Office)', '456 Business Ave, Suite 200, Chicago, IL, 60601', '+1 (555) 987-6543'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          final selectedAddress = state.addresses.where((e) => e.id == state.selectedAddressId).isEmpty
              ? null
              : state.addresses.firstWhere((e) => e.id == state.selectedAddressId);

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StepCircle(step: 1, active: true, label: 'Address'),
                    _StepCircle(step: 2, active: false, label: 'Payment'),
                    _StepCircle(step: 3, active: false, label: 'Review'),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Shipping Address', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Where should we deliver your order?', style: TextStyle(fontSize: 16, color: Color(0xFF77839A))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: state.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          ...state.addresses.map(
                            (item) => GestureDetector(
                              onTap: () => context.read<CheckoutBloc>().add(SelectAddress(item.id)),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: state.selectedAddressId == item.id ? Colors.cyan : const Color(0xFFE2E8EF),
                                    width: state.selectedAddressId == item.id ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          state.selectedAddressId == item.id ? Icons.radio_button_checked : Icons.radio_button_off,
                                          color: state.selectedAddressId == item.id ? Colors.cyan : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${item.fullName} (${item.label})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                        const Spacer(),
                                        const Icon(Icons.edit, color: Color(0xFF92A0B3)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text(item.fullAddress, style: const TextStyle(fontSize: 16, color: Color(0xFF2C3852))),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text(item.phone, style: const TextStyle(fontSize: 16, color: Color(0xFF63708A))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _showAddAddressSheet(context),
                            icon: const Icon(Icons.add_circle, color: Colors.cyan),
                            label: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: const BorderSide(color: Color(0xFFD7DEE8), width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE9EEF5))),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Selected Address', style: TextStyle(fontSize: 16, color: Color(0xFF63708A))),
                        Text(
                          selectedAddress == null ? '—' : '${selectedAddress.fullName} (${selectedAddress.label})',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedAddress == null ? null : () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Continue to Payment  →', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddAddressSheet(BuildContext context) async {
    final fullName = TextEditingController();
    final line1 = TextEditingController();
    final city = TextEditingController();
    final state = TextEditingController();
    final zipCode = TextEditingController();
    final phone = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                _input(fullName, 'Full name'),
                _input(line1, 'Street address'),
                _input(city, 'City'),
                _input(state, 'State'),
                _input(zipCode, 'Zip code'),
                _input(phone, 'Phone'),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CheckoutBloc>().add(
                        AddAddress(
                          label: 'Home',
                          fullName: fullName.text.trim(),
                          line1: line1.text.trim(),
                          city: city.text.trim(),
                          state: state.text.trim(),
                          zipCode: zipCode.text.trim(),
                          phone: phone.text.trim(),
                        ),
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save Address'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder()),
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepCircle(step: 1, active: true, label: 'Address'),
                _StepCircle(step: 2, active: false, label: 'Payment'),
                _StepCircle(step: 3, active: false, label: 'Review'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Shipping Address', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
                Text('Where should we deliver your order?', style: TextStyle(fontSize: 18, color: Color(0xFF77839A))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final item = addresses[index];
                final isSelected = selected == index;
                return GestureDetector(
                  onTap: () => setState(() => selected = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: isSelected ? Colors.cyan : const Color(0xFFE2E8EF), width: isSelected ? 2 : 1),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? Colors.cyan : Colors.grey), const SizedBox(width: 8), Text(item.$1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), const Spacer(), const Icon(Icons.edit, color: Color(0xFF92A0B3))]),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(item.$2, style: const TextStyle(fontSize: 17, color: Color(0xFF2C3852))),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(item.$3, style: const TextStyle(fontSize: 17, color: Color(0xFF63708A))),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Selected Address', style: TextStyle(fontSize: 16, color: Color(0xFF63708A))), Text(addresses[selected].$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.cyan), child: const Text('Continue to Payment  →', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final bool active;
  final String label;
  const _StepCircle({required this.step, required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: active ? Colors.cyan : const Color(0xFFE9EDF3),
          child: Text(
            '$step',
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF63708A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: active ? Colors.cyan : const Color(0xFFA1ACBE), fontWeight: FontWeight.w700)),
      ],
    );
    return Column(children: [CircleAvatar(radius: 20, backgroundColor: active ? Colors.cyan : const Color(0xFFE9EDF3), child: Text('$step', style: TextStyle(color: active ? Colors.white : const Color(0xFF63708A), fontWeight: FontWeight.w700))), const SizedBox(height: 6), Text(label, style: TextStyle(color: active ? Colors.cyan : const Color(0xFFA1ACBE), fontWeight: FontWeight.w700))]);
  }
}
