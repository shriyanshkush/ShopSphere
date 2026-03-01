// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shopsphere/features/admin/data/models/admin_dashboard_model.dart';
// import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
// import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
// import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';
// import 'package:shopsphere/features/admin/presentation/pages/admin_best_selling_products_page.dart';
// import 'package:shopsphere/features/admin/presentation/pages/admin_low_inventory_alerts_page.dart';
//
// class AdminDashboardPage extends StatefulWidget {
//   const AdminDashboardPage({super.key});
//
//   @override
//   State<AdminDashboardPage> createState() => _AdminDashboardPageState();
// }
//
// class _AdminDashboardPageState extends State<AdminDashboardPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminBloc>().add(LoadDashboard());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F2F4),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
//       ),
//       body: BlocBuilder<AdminBloc, AdminState>(
//         builder: (context, state) {
//           if (state is AdminLoading) return const Center(child: CircularProgressIndicator());
//           if (state is AdminError) return Center(child: Text(state.message));
//           if (state is! AdminDashboardLoaded) return const SizedBox.shrink();
//
//           final AdminDashboardModel data = state.dashboard;
//           final bestSellersPreview = data.topProducts.take(3).toList();
//           final lowInventoryPreview = data.lowStockProducts.take(3).toList();
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 1.15,
//                   children: [
//                     _StatCard(title: 'TOTAL REVENUE', value: '\$${data.totalRevenue.toStringAsFixed(0)}', change: 'Live', isUp: true),
//                     _StatCard(title: 'TOTAL ORDERS', value: data.totalOrders.toString(), change: 'Live', isUp: true),
//                     _StatCard(title: 'TOTAL USERS', value: data.totalUsers.toString(), change: 'Live', isUp: true),
//                     _StatCard(title: 'LOW STOCK', value: data.lowStockProducts.length.toString(), change: 'Needs action', isUp: false),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 _RevenueCard(totalRevenue: data.totalRevenue),
//                 const SizedBox(height: 18),
//                 _SectionHeader(
//                   title: 'Best Selling Products',
//                   onSeeAll: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => BlocProvider.value(
//                         value: context.read<AdminBloc>(),
//                         child: const AdminBestSellingProductsPage(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 _RoundedSection(
//                   children: bestSellersPreview.isEmpty
//                       ? const [Padding(padding: EdgeInsets.all(16), child: Text('No best-selling products found'))]
//                       : bestSellersPreview
//                           .map((item) => _ProductRow(item.name, item.category, '${item.soldCount}'))
//                           .expand((w) => [w, const Divider(height: 1)])
//                           .toList()
//                         ..removeLast(),
//                 ),
//                 const SizedBox(height: 18),
//                 _SectionHeader(
//                   title: 'Low Inventory Alerts',
//                   onSeeAll: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => BlocProvider.value(
//                         value: context.read<AdminBloc>(),
//                         child: const AdminLowInventoryAlertsPage(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 _RoundedSection(
//                   children: lowInventoryPreview.isEmpty
//                       ? const [Padding(padding: EdgeInsets.all(16), child: Text('No low inventory alerts found'))]
//                       : lowInventoryPreview
//                           .map((item) => _AlertRow(item.name, item.sku ?? '--', '${item.quantity} LEFT'))
//                           .expand((w) => [w, const Divider(height: 1)])
//                           .toList()
//                         ..removeLast(),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback onSeeAll;
//
//   const _SectionHeader({required this.title, required this.onSeeAll});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//         const Spacer(),
//         TextButton(onPressed: onSeeAll, child: const Text('See all')),
//       ],
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String change;
//   final bool isUp;
//
//   const _StatCard({required this.title, required this.value, required this.change, required this.isUp});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = isUp ? const Color(0xFF03B16F) : const Color(0xFFE83A57);
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE7EAEE)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontSize: 11, letterSpacing: 1.4, color: Color(0xFF667084))),
//           const SizedBox(height: 8),
//           Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
//           const Spacer(),
//           Row(
//             children: [
//               Icon(isUp ? Icons.trending_up : Icons.warning_amber_rounded, size: 15, color: c),
//               const SizedBox(width: 4),
//               Text(change, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _RevenueCard extends StatelessWidget {
//   final double totalRevenue;
//   const _RevenueCard({required this.totalRevenue});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xFFE7EAEE)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Text('Revenue Trends', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
//               Spacer(),
//               Icon(Icons.more_horiz, color: Color(0xFF98A1B2)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           const Text('Monthly Performance', style: TextStyle(color: Color(0xFF667084), fontSize: 15)),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text('\$${totalRevenue.toStringAsFixed(0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
//               const SizedBox(width: 8),
//               const Text('Total', style: TextStyle(color: Color(0xFF667084), fontWeight: FontWeight.w700, fontSize: 14)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _RoundedSection extends StatelessWidget {
//   final List<Widget> children;
//   const _RoundedSection({required this.children});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE7EAEE)),
//       ),
//       child: Column(children: children),
//     );
//   }
// }
//
// class _ProductRow extends StatelessWidget {
//   final String name;
//   final String category;
//   final String sales;
//   const _ProductRow(this.name, this.category, this.sales);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(14),
//       child: Row(
//         children: [
//           Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(color: const Color(0xFFE9EDF3), borderRadius: BorderRadius.circular(10)),
//             child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF667084)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
//               Text(category, style: const TextStyle(fontSize: 14, color: Color(0xFF667084))),
//             ]),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(sales, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
//               const Text('SALES', style: TextStyle(color: Color(0xFF98A1B2), fontWeight: FontWeight.w600)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class _AlertRow extends StatelessWidget {
//   final String name;
//   final String sku;
//   final String count;
//   const _AlertRow(this.name, this.sku, this.count);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(14),
//       child: Row(
//         children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: const BoxDecoration(color: Color(0xFFFFEEF1), shape: BoxShape.circle),
//             child: const Icon(Icons.priority_high_rounded, color: Color(0xFFE83A57)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
//               Text('SKU: $sku', style: const TextStyle(color: Color(0xFF667084))),
//             ]),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(color: const Color(0xFFFFEEF1), borderRadius: BorderRadius.circular(20)),
//             child: Text(count, style: const TextStyle(color: Color(0xFFE83A57), fontWeight: FontWeight.w700)),
//           )
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/data/models/admin_dashboard_model.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_best_selling_products_page.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_low_inventory_alerts_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) return const Center(child: CircularProgressIndicator());
          if (state is AdminError) return Center(child: Text(state.message));
          if (state is! AdminDashboardLoaded) return const SizedBox.shrink();

          final AdminDashboardModel data = state.dashboard;
          final bestSellersPreview = data.topProducts.take(3).toList();
          final lowInventoryPreview = data.lowStockProducts.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    _StatCard(title: 'TOTAL REVENUE', value: '\$${data.totalRevenue.toStringAsFixed(0)}', change: 'Live', isUp: true),
                    _StatCard(title: 'TOTAL ORDERS', value: data.totalOrders.toString(), change: 'Live', isUp: true),
                    _StatCard(title: 'TOTAL USERS', value: data.totalUsers.toString(), change: 'Live', isUp: true),
                    _StatCard(title: 'LOW STOCK', value: data.lowStockProducts.length.toString(), change: 'Needs action', isUp: false),
                  ],
                ),
                const SizedBox(height: 18),
                _RevenueCard(totalRevenue: data.totalRevenue),
                const SizedBox(height: 18),
                _SectionHeader(
                  title: 'Best Selling Products',
                  onSeeAll: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AdminBloc>(),
                        child: const AdminBestSellingProductsPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _RoundedSection(
                  children: bestSellersPreview.isEmpty
                      ? const [Padding(padding: EdgeInsets.all(16), child: Text('No best-selling products found'))]
                      : List.generate(bestSellersPreview.length, (index) {
                    final item = bestSellersPreview[index];
                    return Column(
                      children: [
                        _ProductRow(item.name, item.category, '${item.soldCount}'),
                        if (index != bestSellersPreview.length - 1) const Divider(height: 1),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 18),
                _SectionHeader(
                  title: 'Low Inventory Alerts',
                  onSeeAll: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AdminBloc>(),
                        child: const AdminLowInventoryAlertsPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _RoundedSection(
                  children: lowInventoryPreview.isEmpty
                      ? const [Padding(padding: EdgeInsets.all(16), child: Text('No low inventory alerts found'))]
                      : List.generate(lowInventoryPreview.length, (index) {
                    final item = lowInventoryPreview[index];
                    return Column(
                      children: [
                        _AlertRow(item.name, item.sku ?? '--', '${item.quantity} LEFT'),
                        if (index != lowInventoryPreview.length - 1) const Divider(height: 1),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const Spacer(),
        TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isUp;

  const _StatCard({required this.title, required this.value, required this.change, required this.isUp});

  @override
  Widget build(BuildContext context) {
    final c = isUp ? const Color(0xFF03B16F) : const Color(0xFFE83A57);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EAEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, letterSpacing: 1.4, color: Color(0xFF667084))),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const Spacer(),
          Row(
            children: [
              Icon(isUp ? Icons.trending_up : Icons.warning_amber_rounded, size: 15, color: c),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final double totalRevenue;
  const _RevenueCard({required this.totalRevenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EAEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('Revenue Trends', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              Spacer(),
              Icon(Icons.more_horiz, color: Color(0xFF98A1B2)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Monthly Performance', style: TextStyle(color: Color(0xFF667084), fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${totalRevenue.toStringAsFixed(0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              const Text('Total', style: TextStyle(color: Color(0xFF667084), fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundedSection extends StatelessWidget {
  final List<Widget> children;
  const _RoundedSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EAEE)),
      ),
      child: Column(children: children),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final String name;
  final String category;
  final String sales;
  const _ProductRow(this.name, this.category, this.sales);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: const Color(0xFFE9EDF3), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF667084)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(category, style: const TextStyle(fontSize: 14, color: Color(0xFF667084))),
            ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(sales, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const Text('SALES', style: TextStyle(color: Color(0xFF98A1B2), fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final String name;
  final String sku;
  final String count;
  const _AlertRow(this.name, this.sku, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(color: Color(0xFFFFEEF1), shape: BoxShape.circle),
            child: const Icon(Icons.priority_high_rounded, color: Color(0xFFE83A57)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('SKU: $sku', style: const TextStyle(color: Color(0xFF667084))),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFFFEEF1), borderRadius: BorderRadius.circular(20)),
            child: Text(count, style: const TextStyle(color: Color(0xFFE83A57), fontWeight: FontWeight.w700)),
          )
        ],
      ),
    );
  }
}