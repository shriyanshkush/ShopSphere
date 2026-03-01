import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/orders/data/models/order_summary_model.dart';
import 'package:shopsphere/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shopsphere/features/orders/presentation/bloc/orders_event.dart';
import 'package:shopsphere/features/orders/presentation/bloc/orders_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrders());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (value) => context.read<OrdersBloc>().add(SearchOrders(value)),
                  decoration: InputDecoration(
                    hintText: 'Search by order ID or item...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFEFF3F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _tab('All', OrderFilterTab.all, state.selectedTab),
                    _tab('Ongoing', OrderFilterTab.ongoing, state.selectedTab),
                    _tab('Completed', OrderFilterTab.completed, state.selectedTab),
                    _tab('Cancelled', OrderFilterTab.cancelled, state.selectedTab),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => context.read<OrdersBloc>().add(LoadOrders()),
                  child: state.loadingList
                      ? const Center(child: CircularProgressIndicator())
                      : state.visibleOrders.isEmpty
                          ? ListView(children: const [SizedBox(height: 160), Center(child: Text('No orders found'))])
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                              itemCount: state.visibleOrders.length,
                              itemBuilder: (_, i) {
                                final order = state.visibleOrders[i];
                                return _OrderCard(order: order);
                              },
                            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tab(String title, OrderFilterTab tab, OrderFilterTab selected) {
    final isSelected = tab == selected;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => context.read<OrdersBloc>().add(FilterOrdersByTab(tab)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF17D4E6) : const Color(0xFFEFF3F8),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF4A5C78),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderSummaryModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM dd, yyyy').format(order.orderedAt);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.orderDetails, arguments: order.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(color: const Color(0xFFE8F7FA), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.local_shipping_outlined, color: Color(0xFF0FC6CF)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ORDER ${order.orderCode}', style: const TextStyle(color: Color(0xFF8A9AB2), fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('$date • ${order.itemCount} Items', style: const TextStyle(fontSize: 22 / 1.25, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                _statusPill(order.statusLabel),
              ],
            ),
            const Divider(height: 26, color: Color(0xFFF0F3F7)),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: order.firstItemImage.isNotEmpty
                      ? Image.network(order.firstItemImage, width: 86, height: 86, fit: BoxFit.cover)
                      : Container(width: 86, height: 86, color: const Color(0xFFEFF3F8), child: const Icon(Icons.image_not_supported_outlined)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.firstItemName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18 / 1.05, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(order.firstItemSubtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF73849D))),
                      const SizedBox(height: 8),
                      Text('\$${order.firstItemPrice.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF00C7DE), fontSize: 34 / 1.25, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFBBC5D4)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg;
    Color fg;
    if (status == 'Delivered') {
      bg = const Color(0xFFDDF7E7);
      fg = const Color(0xFF0AA84F);
    } else if (status == 'Cancelled') {
      bg = const Color(0xFFFFE2E2);
      fg = const Color(0xFFE33A3A);
    } else {
      bg = const Color(0xFFE7F1FF);
      fg = const Color(0xFF2F7BEA);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
    );
  }
}
