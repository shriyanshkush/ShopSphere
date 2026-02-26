import 'package:flutter/material.dart';

class OrderConfirmedArgs {
  final String orderNumber;
  final String estimateDate;
  final double subtotal;
  final double shipping;
  final double tax;

  const OrderConfirmedArgs({
    required this.orderNumber,
    required this.estimateDate,
    required this.subtotal,
    required this.shipping,
    required this.tax,
  });

  double get totalPaid => subtotal + shipping + tax;
}

class OrderConfirmedPage extends StatelessWidget {
  final OrderConfirmedArgs args;

  const OrderConfirmedPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: Color(0xFFDFF6E5),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF22C55E),
                  child: Icon(Icons.check, color: Colors.white, size: 34),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('Thank You!', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            const Center(child: Text('Your order has been placed successfully.')),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _box('Order Number', args.orderNumber)),
                const SizedBox(width: 12),
                Expanded(child: _box('Estimated Delivery', args.estimateDate)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Order Summary', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _line('Subtotal', args.subtotal),
            _line('Shipping', args.shipping),
            _line('Tax', args.tax),
            const Divider(height: 30),
            _line('Total Paid', args.totalPaid, highlight: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text('Continue Shopping'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _box(String title, String value) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w700))]),
      );

  Widget _line(String label, double amount, {bool highlight = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontWeight: highlight ? FontWeight.w700 : FontWeight.w500)),
            const Spacer(),
            Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(color: highlight ? Colors.cyan : Colors.black, fontWeight: highlight ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      );
}
