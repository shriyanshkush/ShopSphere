import 'package:flutter/material.dart';
import 'package:shopsphere/core/constants/Routes.dart';

class CheckoutReviewPage extends StatelessWidget {
  const CheckoutReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepCircle(step: 1, active: true, label: 'Address'),
                _StepCircle(step: 2, active: true, label: 'Payment'),
                _StepCircle(step: 3, active: true, label: 'Review'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Review Your Order', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Confirm the details before placing your order.', style: TextStyle(fontSize: 16, color: Color(0xFF77839A))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SummaryCard(
                  title: 'Delivery Address',
                  subtitle: 'Jane Doe • 123 Maple St, Springfield, IL',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                _SummaryCard(
                  title: 'Payment',
                  subtitle: 'Razorpay Checkout',
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 12),
                _SummaryCard(
                  title: 'Order Summary',
                  subtitle: '3 items • Total: \$787.00',
                  icon: Icons.shopping_bag_outlined,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Place Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8EF)),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE6F7F8),
            child: Icon(icon, color: Colors.cyan),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF63708A))),
              ],
            ),
          ),
        ],
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
  }
}
