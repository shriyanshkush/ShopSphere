import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/data/models/admin_order_model.dart';
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
  final filters = ['All', 'Pending', 'Confirmed', 'Packed', 'Shipped', 'Delivered', 'Cancelled'];

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
        title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.w700)),
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
                      fontSize: 15,
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

                List<AdminOrderModel> orders = List<AdminOrderModel>.from(state.orders);
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
                  itemBuilder: (_, i) => _OrderCard(order: orders[i]),
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
  final AdminOrderModel order;
  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(widget.order.status);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.25)),
                ),
                child: Icon(Icons.receipt_long, color: statusColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#ORD-${widget.order.id.substring(0, 4).toUpperCase()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(_formatDate(widget.order.orderedAt), style: const TextStyle(color: Color(0xFF5B7F84), fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${widget.order.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: statusColor),
                      const SizedBox(width: 6),
                      Text(widget.order.status, style: const TextStyle(color: Color(0xFF5B7F84), fontSize: 13)),
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
                    Text('Update to next stage', style: TextStyle(color: Color(0xFF5B7F84), fontSize: 12)),
                  ]),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BC8DE),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: widget.order.statusCode >= 4
                        ? null
                        : () => context.read<AdminBloc>().add(UpdateOrderStatus(widget.order.id, widget.order.statusCode + 1)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Text('Move Next', style: TextStyle(fontWeight: FontWeight.w700)),
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
                    const Text('Quick View', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  ]),
                  if (expanded) ...[
                    const Divider(height: 22, color: Color(0xFFD2DDE1)),
                    ...widget.order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ItemRow(
                        item.name,
                        'Qty: ${item.quantity} • \$${item.unitPrice.toStringAsFixed(2)}',
                        '\$${item.total.toStringAsFixed(2)}',
                      ),
                    )),
                    if (widget.order.items.isEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('No item details found', style: TextStyle(color: Color(0xFF5B7F84))),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF4B400);
      case 'confirmed':
        return const Color(0xFF6366F1);
      case 'packed':
        return const Color(0xFF8B5CF6);
      case 'shipped':
        return const Color(0xFF60A5FA);
      case 'delivered':
        return const Color(0xFF22C55E);
      case 'cancelled':
        return const Color(0xFFEF4444);
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
          width: 42,
          height: 42,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF98A1B2)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Text(subtitle, style: const TextStyle(color: Color(0xFF5B7F84), fontSize: 13)),
          ]),
        ),
        Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
      ],
    );
  }
}
