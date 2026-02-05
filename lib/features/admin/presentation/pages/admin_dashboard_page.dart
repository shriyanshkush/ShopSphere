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
      appBar: _buildAppBar(),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminDashboardLoaded) {
            final data = state.dashboard;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsGrid(data),
                  const SizedBox(height: 24),
                  _RevenueCard(data),
                  const SizedBox(height: 24),
                  _BestSellingSection(),
                  const SizedBox(height: 24),
                  _LowInventorySection(),
                ],
              ),
            );
          }

          if (state is AdminError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Dashboard'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final dynamic data;
  const _StatsGrid(this.data);

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      children: [
        _StatCard(
          title: 'TOTAL REVENUE',
          value: '\$${data.totalRevenue.toStringAsFixed(0)}',
          change: '+12.5%',
          positive: true,
        ),
        _StatCard(
          title: 'TOTAL ORDERS',
          value: data.totalOrders.toString(),
          change: '+8.2%',
          positive: true,
        ),
        _StatCard(
          title: 'TOTAL USERS',
          value: data.totalUsers.toString(),
          change: '+5.4%',
          positive: true,
        ),
        const _StatCard(
          title: 'CONV. RATE',
          value: '3.2%',
          change: '-0.2%',
          positive: false,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, change;
  final bool positive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          Row(
            children: [
              Icon(
                positive ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(color: color)),
            ],
          )
        ],
      ),
    );
  }
}


class _RevenueCard extends StatelessWidget {
  final dynamic data;
  const _RevenueCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Colors.black12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revenue Trends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Monthly Performance',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Text(
            '\$${data.totalRevenue.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            alignment: Alignment.center,
            child: const Text('📈 Chart goes here'),
          )
        ],
      ),
    );
  }
}


class _BestSellingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Best Selling Products',
      children: const [
        _ProductTile('Premium Headphones', 'Electronics', '432'),
        _ProductTile('Smart Watch Pro', 'Wearables', '298'),
        _ProductTile('Leather Wallet', 'Accessories', '185'),
      ],
    );
  }
}


class _LowInventorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Low Inventory Alerts',
      children: const [
        _AlertTile('USB-C Fast Cable', 'CBL-042', '2 LEFT'),
        _AlertTile('Wireless Mouse', 'MSE-119', '5 LEFT'),
      ],
    );
  }
}


class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  final String name, category, sales;

  const _ProductTile(this.name, this.category, this.sales);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
      title: Text(name),
      subtitle: Text(category),
      trailing: Text('$sales SALES'),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String name, sku, count;

  const _AlertTile(this.name, this.sku, this.count);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.warning, color: Colors.red),
      title: Text(name),
      subtitle: Text('SKU: $sku'),
      trailing: Chip(
        label: Text(count),
        backgroundColor: Colors.red.shade50,
        labelStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}

