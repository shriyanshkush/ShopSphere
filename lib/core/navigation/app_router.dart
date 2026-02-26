import 'package:flutter/material.dart';
import 'package:shopsphere/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_shell_page.dart';
import 'package:shopsphere/features/home/data/datasources/%20home_remote_data_source.dart';
import 'package:shopsphere/features/home/data/repositories/home_repository_impl.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/pages/home_page.dart';
import 'package:shopsphere/features/product_detail/data/datasources/product_detail_remote_data_source.dart';
import 'package:shopsphere/features/product_detail/data/repositories/product_detail_repository_impl.dart';
import 'package:shopsphere/features/product_detail/presentation/bloc/product_detail_bloc.dart';
import 'package:shopsphere/features/product_detail/presentation/pages/product_detail_page.dart';
import 'package:shopsphere/features/product_detail/presentation/pages/order_confirmed_page.dart';
import 'package:shopsphere/features/profile/presentation/pages/profile_page.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../constants/Routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _page(const SplashPage());

      case Routes.onboarding:
        return _page(const OnboardingPage());

      case Routes.login:
        return _page(const LoginPage());

      case Routes.signup:
        return _page(const SignupPage());

      case Routes.home:
        return _page(
          BlocProvider(
            create: (_) => HomeBloc(
              HomeRepositoryImpl(
                HomeRemoteDataSource(),
              ),
            ),
            child: const HomePage(),
          ),
        );


      case Routes.admin:
        return _page(
          BlocProvider(
            create: (_) => AdminBloc(AdminRepositoryImpl()),
            child: const AdminShellPage(),
          ),
        );

      case Routes.productDetail:
        final productId = settings.arguments as String;

        return _page(
          BlocProvider(
            create: (_) => ProductDetailBloc(
              ProductDetailRepositoryImpl(
                ProductDetailRemoteDataSource(),
              ),
            ),
            child: ProductDetailPage(productId: productId),
          ),
        );

      case Routes.profile:
        return _page(const ProfilePage());

      case Routes.orderConfirmed:
        final args = settings.arguments as OrderConfirmedArgs;
        return _page(OrderConfirmedPage(args: args));



      default:
        return _page(
          const Scaffold(
            body: Center(child: Text('❌ Route not found')),
          ),
        );
    }
  }

  static PageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
