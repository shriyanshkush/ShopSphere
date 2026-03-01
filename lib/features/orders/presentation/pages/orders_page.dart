import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/orders/domain/repositories/orders_repository.dart';

import '../../data/models/order_model.dart';

class OrdersPage extends StatefulWidget {
  final OrdersRepository repository;

  const OrdersPage({super.key, required this.repository});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

enum _OrderFilter { all, ongoing, completed, cancelled }

class _OrdersPageState extends State<OrdersPage> {
  _OrderFilter _selectedFilter = _OrderFilter.all;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    final query = _searchController.text.trim().toLowerCase();

    return orders.where((order) {
      final byTab = switch (_selectedFilter) {
        _OrderFilter.all => true,
        _OrderFilter.ongoing => order.isOngoing,
        _OrderFilter.completed => order.isCompleted,
        _OrderFilter.cancelled => order.isCancelled,
      };

      if (!byTab) return false;
      if (query.isEmpty) return true;

      final firstItem = order.products.isNotEmpty ? order.products.first.name : '';
      return order.id.toLowerCase().contains(query) ||
          firstItem.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F5F7),
        foregroundColor: const Color(0xFF0F172A),
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: widget.repository.getMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load orders: ${snapshot.error}'));
          }

          final allOrders = snapshot.data ?? const <OrderModel>[];
          final filtered = _filterOrders(allOrders);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by order ID or item...',
                    filled: true,
                    fillColor: const Color(0xFFE6EAF0),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
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
                    _buildFilterChip('All', _OrderFilter.all),
                    _buildFilterChip('Ongoing', _OrderFilter.ongoing),
                    _buildFilterChip('Completed', _OrderFilter.completed),
                    _buildFilterChip('Cancelled', _OrderFilter.cancelled),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No orders found'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                        itemBuilder: (context, index) => _OrderCard(
                          order: filtered[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.orderDetails,
                              arguments: filtered[index].id,
                            );
                          },
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: filtered.length,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, _OrderFilter filter) {
    final isSelected = filter == _selectedFilter;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = filter),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF334155),
          fontWeight: FontWeight.w600,
        ),
        selectedColor: const Color(0xFF17C3D6),
        backgroundColor: const Color(0xFFE7EBF0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final firstItem = order.products.isNotEmpty ? order.products.first : null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F8FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_shipping_outlined,
                        color: Color(0xFF17C3D6)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORDER #${order.id.substring(0, order.id.length.clamp(0, 8).toInt()).toUpperCase()}',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${DateFormat('MMM dd, yyyy').format(order.orderedAt)} • ${order.products.length} Items',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(order),
                ],
              ),
              const Divider(height: 26),
              Row(
                children: [
                  _OrderImage(imageUrl: (firstItem != null && firstItem.images.isNotEmpty) ? firstItem.images.first : null),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem?.name ?? 'Order Items',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          firstItem?.description ?? 'View ordered items',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF17C3D6),
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFB0B8C3)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(OrderModel order) {
    Color bg;
    Color fg;

    if (order.isCompleted) {
      bg = const Color(0xFFD8F6E5);
      fg = const Color(0xFF16A34A);
    } else if (order.isCancelled) {
      bg = const Color(0xFFFDE2E2);
      fg = const Color(0xFFDC2626);
    } else {
      bg = const Color(0xFFDCEBFF);
      fg = const Color(0xFF2563EB);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        order.statusLabel,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _OrderImage extends StatelessWidget {
  final String? imageUrl;

  const _OrderImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.shopping_bag_outlined),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 80,
          color: const Color(0xFFF1F5F9),
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
