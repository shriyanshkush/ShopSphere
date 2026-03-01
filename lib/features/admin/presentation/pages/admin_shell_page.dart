import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_inventory_page.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_orders_page.dart';

import '../ bloc/admin_bloc.dart';
import '../ bloc/admin_event.dart';

class AdminShellPage extends StatefulWidget {
  const AdminShellPage({super.key});

  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {

  @override
  void initState() {
    super.initState();
    // Load dashboard on first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminBloc>().add(LoadDashboard());
    });
  }


  int index = 0;

  final pages = const [
    AdminDashboardPage(),
    AdminOrdersPage(),
    AdminInventoryPage(),
    _AdminSettingsPlaceholderPage(),
  ];

  void _onTabChanged(int i) {
    setState(() => index = i);

    final bloc = context.read<AdminBloc>();

    if (i == 0) bloc.add(LoadDashboard());
    if (i == 1) bloc.add(LoadOrders());
    if (i == 2) bloc.add(LoadInventory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF19C8DC),
        unselectedItemColor: const Color(0xFF98A1B2),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        onTap: _onTabChanged,   // ✅ use this
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _AdminSettingsPlaceholderPage extends StatelessWidget {
  const _AdminSettingsPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings coming soon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
