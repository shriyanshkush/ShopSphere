import 'package:flutter/material.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:shopsphere/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:shopsphere/features/checkout/presentation/models/checkout_flow_args.dart';

class CheckoutReviewPage extends StatefulWidget {
  final CheckoutReviewArgs? args;
  const CheckoutReviewPage({super.key, this.args});

  @override
  State<CheckoutReviewPage> createState() => _CheckoutReviewPageState();
}

class _CheckoutReviewPageState extends State<CheckoutReviewPage> {
  bool _loading = true;
  bool _submitting = false;
  List<dynamic> _cartItems = [];
  double _cartTotal = 0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final repo = CheckoutRepositoryImpl(CheckoutRemoteDataSource());
      final cart = await repo.fetchCart();
      setState(() {
        _cartItems = (cart['items'] as List? ?? []);
        _cartTotal = (cart['totalAmount'] as num?)?.toDouble() ?? 0;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load cart summary')),
      );
    }
  }

  Future<void> _placeOrder() async {
    final args = widget.args;
    if (args == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing checkout details.')),
      );
      return;
    }
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      final repo = CheckoutRepositoryImpl(CheckoutRemoteDataSource());
      await repo.placeOrder(
        cart: _cartItems,
        totalPrice: _cartTotal,
        address: '${args.address.fullName} • ${args.address.fullAddress}',
        payment: args.payment.toJson(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order.')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final paymentLabel = args == null
        ? 'Payment method'
        : args.payment.method == 'cod'
            ? 'Cash on Delivery'
            : 'Razorpay Checkout';
    final itemCount = _cartItems.fold<int>(0, (sum, item) => sum + ((item['quantity'] as num?)?.toInt() ?? 0));

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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _SummaryCard(
                        title: 'Delivery Address',
                        subtitle: args == null ? '—' : '${args.address.fullName} • ${args.address.fullAddress}',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 12),
                      _SummaryCard(
                        title: 'Payment',
                        subtitle: paymentLabel,
                        icon: Icons.credit_card,
                      ),
                      const SizedBox(height: 12),
                      _SummaryCard(
                        title: 'Order Summary',
                        subtitle: '$itemCount items • Total: ₹${_cartTotal.toStringAsFixed(2)}',
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
                onPressed: _submitting ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _submitting
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Place Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
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
