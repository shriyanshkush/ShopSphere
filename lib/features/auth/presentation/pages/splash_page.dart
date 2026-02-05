import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/core/services/auth_local_storage.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_shell_page.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // 🔥 Trigger auth check
    Future.microtask(() {
      context.read<AuthBloc>().add(AppStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {

          if (state is AuthAuthenticated) {
            final user = await AuthLocalStorage().getUser();

            if (user?.type == 'admin') {
              Navigator.pushReplacementNamed(context, Routes.admin);

            } else {
              Navigator.pushReplacementNamed(context, Routes.home);
            }
          }


          if (state is AuthUnauthenticated) {
            await Future.delayed(const Duration(milliseconds: 800));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingPage()),
            );
          }
        },
        child: _SplashUI(),
      ),
    );
  }
}


class _SplashUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1ECAD3),
            Color(0xFF0FA3B1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 80,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'ShopHub',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Ultimate Shopping Destination',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),

        ],
      ),
    );
  }
}
