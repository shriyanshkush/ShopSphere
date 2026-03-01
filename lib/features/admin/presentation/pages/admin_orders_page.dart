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
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1BC8DE),
        onPressed: () {},
        child: const Icon(Icons.add, size: 38, color: Colors.black),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filters.length,
              itemBuilder: (_, i) {
                final selected = selectedFilter == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(filters[i]),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => selectedFilter = i),
                    selectedColor: const Color(0xFF1BC8DE),
                    backgroundColor: const Color(0xFFE8EBEF),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontSize: 18 / 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminError) {
                  return Center(child: Text(state.message));
                }
                if (state is! AdminOrdersLoaded) {
                  return const SizedBox.shrink();
                }

                var orders = state.orders;
                if (selectedFilter > 0) {
                  final selected = filters[selectedFilter].toLowerCase();
                  orders = orders.where((e) => e.status.toLowerCase() == selected).toList();
                }

                if (orders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }

                return ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => _OrderCard(order: orders[i], initiallyExpanded: i == 0),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final dynamic order;
  final bool initiallyExpanded;
  const _OrderCard({required this.order, required this.initiallyExpanded});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(widget.order.status);
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: expanded ? const Color(0xFF1BC8DE) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: expanded ? const Color(0xFF1BC8DE) : const Color(0xFFD0D5DD)),
                ),
                child: expanded ? const Icon(Icons.check, color: Colors.white) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#ORD-${widget.order.id.substring(0, 4)}', style: const TextStyle(fontSize: 40 / 2, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    const Text('Alex Johnson • Oct 24, 2023', style: TextStyle(color: Color(0xFF5B7F84), fontSize: 35 / 2.5)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${widget.order.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22 / 1.3)),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: statusColor),
                      const SizedBox(width: 6),
                      Text(widget.order.status, style: TextStyle(color: const Color(0xFF5B7F84), fontSize: 34 / 2.4)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD2DDE1)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                    SizedBox(height: 4),
                    Text('Action Required', style: TextStyle(color: Color(0xFF5B7F84), fontSize: 34 / 2.5)),
                  ]),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BC8DE),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => context.read<AdminBloc>().add(UpdateOrderStatus(widget.order.id, 3)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(children: [Text('Update', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(width: 8), Icon(Icons.keyboard_arrow_down)]),
                    ),
                  )
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFE8ECEF), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.shopping_bag_outlined, color: Color(0xFF5B7F84)),
                    const SizedBox(width: 10),
                    const Text('Quick View', style: TextStyle(fontSize: 36 / 2, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  ]),
                  if (expanded) ...[
                    const Divider(height: 22, color: Color(0xFFD2DDE1)),
                    const _ItemRow('Wireless Headphones', 'Qty: 1 • \$89.00', '\$89.00'),
                    const SizedBox(height: 12),
                    const _ItemRow('USB-C Cable (2m)', 'Qty: 1 • \$35.50', '\$35.50'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF4B400);
      case 'processing':
        return const Color(0xFF6366F1);
      case 'shipped':
        return const Color(0xFF60A5FA);
      case 'delivered':
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFF94A3B8);
    }
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  const _ItemRow(this.title, this.subtitle, this.price);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: const Icon(Icons.headphones, color: Color(0xFF98A1B2)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 35 / 2.1, fontWeight: FontWeight.w500)),
            Text(subtitle, style: const TextStyle(color: Color(0xFF5B7F84), fontSize: 33 / 2.5)),
          ]),
        ),
        Text(price, style: const TextStyle(fontSize: 35 / 2.1, fontWeight: FontWeight.w500))
      ],
    );
  }
}
