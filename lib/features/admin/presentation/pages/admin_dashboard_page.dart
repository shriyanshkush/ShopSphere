import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';

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
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminError) {
            return Center(child: Text(state.message));
          }
          if (state is! AdminDashboardLoaded) {
            return const SizedBox.shrink();
          }

          final data = state.dashboard;
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
                    _StatCard(title: 'TOTAL REVENUE', value: '\$${data.totalRevenue.toStringAsFixed(0)}', change: '+12.5%', isUp: true),
                    _StatCard(title: 'TOTAL ORDERS', value: data.totalOrders.toString(), change: '+8.2%', isUp: true),
                    _StatCard(title: 'TOTAL USERS', value: data.totalUsers.toString(), change: '+5.4%', isUp: true),
                    const _StatCard(title: 'CONV. RATE', value: '3.2%', change: '-0.2%', isUp: false),
                  ],
                ),
                const SizedBox(height: 18),
                _RevenueCard(totalRevenue: data.totalRevenue),
                const SizedBox(height: 18),
                const Text('Best Selling Products', style: TextStyle(fontSize: 36 / 2, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const _RoundedSection(
                  children: [
                    _ProductRow('Premium Headphones', 'Electronics', '432'),
                    Divider(height: 1),
                    _ProductRow('Smart Watch Pro', 'Wearables', '298'),
                    Divider(height: 1),
                    _ProductRow('Leather Wallet', 'Accessories', '185'),
                  ],
                ),
                const SizedBox(height: 18),
                const Text('Low Inventory Alerts', style: TextStyle(fontSize: 36 / 2, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const _RoundedSection(
                  children: [
                    _AlertRow('USB-C Fast Cable', 'CBL-042', '2 LEFT'),
                    Divider(height: 1),
                    _AlertRow('Wireless Mouse', 'MSE-119', '5 LEFT'),
                  ],
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
              Icon(isUp ? Icons.trending_up : Icons.trending_down, size: 15, color: c),
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
          Row(
            children: const [
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
              Text('\$${totalRevenue.toStringAsFixed(0)}', style: const TextStyle(fontSize: 48 / 1.5, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              const Text('+15.3%', style: TextStyle(color: Color(0xFF03B16F), fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 14),
          const SizedBox(height: 190, child: _SimpleRevenueChart()),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jan', style: TextStyle(color: Color(0xFF98A1B2))),
                Text('Feb', style: TextStyle(color: Color(0xFF98A1B2))),
                Text('Mar', style: TextStyle(color: Color(0xFF98A1B2))),
                Text('Apr', style: TextStyle(color: Color(0xFF98A1B2))),
                Text('May', style: TextStyle(color: Color(0xFF98A1B2))),
                Text('Jun', style: TextStyle(color: Color(0xFF98A1B2))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SimpleRevenueChart extends StatelessWidget {
  const _SimpleRevenueChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RevenuePainter());
  }
}

class _RevenuePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF08C0DA)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..color = const Color(0x2608C0DA)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.88)
      ..cubicTo(size.width * .15, size.height * .82, size.width * .18, size.height * .56, size.width * .3, size.height * .35)
      ..cubicTo(size.width * .43, size.height * .2, size.width * .5, size.height * .95, size.width * .62, size.height * .22)
      ..cubicTo(size.width * .7, size.height * .02, size.width * .78, size.height * .03, size.width * .9, size.height * .96)
      ..cubicTo(size.width * .96, size.height * 1.03, size.width, size.height * .6, size.width, size.height * .18);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
              Text(sales, style: const TextStyle(fontSize: 30 / 2, fontWeight: FontWeight.w700)),
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
