import 'package:flutter/material.dart';

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
    return Column(children: [CircleAvatar(radius: 20, backgroundColor: active ? Colors.cyan : const Color(0xFFE9EDF3), child: Text('$step', style: TextStyle(color: active ? Colors.white : const Color(0xFF63708A), fontWeight: FontWeight.w700))), const SizedBox(height: 6), Text(label, style: TextStyle(color: active ? Colors.cyan : const Color(0xFFA1ACBE), fontWeight: FontWeight.w700))]);
  }
}
