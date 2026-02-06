import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopsphere/core/constants/Routes.dart';

class CheckoutPaymentPage extends StatefulWidget {
  const CheckoutPaymentPage({super.key});

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful!')),
    );
    Navigator.pushNamed(context, Routes.checkoutReview);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message ?? 'Unknown error'}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName ?? ''}')),
    );
  }

  void _startPayment() {
    final options = {
      'key': 'rzp_test_1234567890',
      'amount': 19900,
      'name': 'ShopSphere',
      'description': 'Order Payment',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@shopsphere.com',
      },
    };

    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(fontWeight: FontWeight.w700)),
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
                _StepCircle(step: 3, active: false, label: 'Review'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose Payment Method', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Pay securely with Razorpay Checkout.', style: TextStyle(fontSize: 16, color: Color(0xFF77839A))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _PaymentOption(
                  title: 'Razorpay Checkout',
                  subtitle: 'Cards, UPI, Netbanking, and Wallets',
                  icon: Icons.lock_outline,
                  onTap: _startPayment,
                ),
                const SizedBox(height: 12),
                _PaymentOption(
                  title: 'Cash on Delivery',
                  subtitle: 'Pay when your order arrives',
                  icon: Icons.payments_outlined,
                  onTap: () => Navigator.pushNamed(context, Routes.checkoutReview),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              'By proceeding, you agree to the Razorpay payment terms.',
              style: TextStyle(color: Color(0xFF77839A)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            const Icon(Icons.chevron_right),
          ],
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
  }
}
