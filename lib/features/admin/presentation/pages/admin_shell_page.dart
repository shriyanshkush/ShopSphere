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
    //AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Catalog'),
          //BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
