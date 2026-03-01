import 'package:flutter/material.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_inventory_page.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_orders_page.dart';

class AdminShellPage extends StatefulWidget {
  const AdminShellPage({super.key});

  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  int index = 0;

  final pages = const [
    AdminDashboardPage(),
    AdminOrdersPage(),
    AdminInventoryPage(),
    _AdminSettingsPlaceholderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF19C8DC),
        unselectedItemColor: const Color(0xFF98A1B2),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
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
