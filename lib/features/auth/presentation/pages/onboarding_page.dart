import 'package:flutter/material.dart';
import '../../../../common/widgets/PrimaryButton.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  final pages = const [
    _OnboardItem(
      title: 'Shop Smart',
      subtitle: 'Discover the best products at the best prices',
      imagePath: 'assets/icons/mobile_ui_illustration.png',
    ),

    _OnboardItem(
      title: 'Fast Delivery',
      subtitle: 'Get your orders delivered quickly and safely.',
      imagePath: 'assets/icons/security_payment_illustration.png',
    ),
    _OnboardItem(
      title: 'Secure Payments',
      subtitle: 'Multiple payment methods with full security.',
      imagePath: 'assets/icons/delivery_van_illustration.png',
    ),
  ];

  void _next() {
    if (_index == pages.length - 1) {
      _goToLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _goToLogin,
                child: const Text('Skip',style: TextStyle(color: Colors.teal,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            _Dots(index: _index, count: pages.length),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                text: "Next",
                onPressed: () {
                   _next();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath; // 👈 new

  const _OnboardItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
        ),
      ],
    );
  }
}


class _Dots extends StatelessWidget {
  final int index;
  final int count;

  const _Dots({required this.index, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == index ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == index ? Colors.teal : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
