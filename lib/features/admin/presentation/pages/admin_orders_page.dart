import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';



class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  int selectedFilter = 0;

  final filters = ['All', 'Pending', 'Processing', 'Shipped', 'Delivered'];

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AdminOrdersLoaded) {
                  final orders = state.orders;

                  if (orders.isEmpty) {
                    return const Center(child: Text('No orders found'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final order = orders[i];
                      return _OrderCard(order);
                    },
                  );
                }

                if (state is AdminError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Orders'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (_, i) {
          final selected = selectedFilter == i;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(filters[i]),
              selected: selected,
              onSelected: (_) => setState(() => selectedFilter = i),
              selectedColor: Colors.teal,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final dynamic order;
  const _OrderCard(this.order);

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(widget.order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(value: false, onChanged: (_) {}),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#ORD-${widget.order.id.substring(0, 4)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Customer Name • Oct 24, 2023',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${widget.order.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        widget.order.status,
                        style: TextStyle(color: statusColor),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'STATUS',
                style: TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  context.read<AdminBloc>().add(
                    UpdateOrderStatus(widget.order.id, 3),
                  );
                },
                child: const Text('Update ▼'),
              )
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => setState(() => expanded = !expanded),
            child: Row(
              children: [
                const Icon(Icons.lock_outline),
                const SizedBox(width: 8),
                const Text('Quick View'),
                const Spacer(),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                )
              ],
            ),
          ),
          if (expanded) _QuickView(),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}


class _QuickView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: const [
          _ItemRow('Wireless Headphones', 'Qty: 1', '\$89.00'),
          _ItemRow('USB-C Cable (2m)', 'Qty: 1', '\$35.50'),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String name, qty, price;
  const _ItemRow(this.name, this.qty, this.price);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(qty, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(price),
        ],
      ),
    );
  }
}

