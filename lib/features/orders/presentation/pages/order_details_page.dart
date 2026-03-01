import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopsphere/features/orders/domain/repositories/orders_repository.dart';

import '../../data/models/order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  final OrdersRepository repository;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7),
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text('Order Details', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder<OrderModel>(
        future: repository.getOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load order details: ${snapshot.error}'),
            );
          }

          final order = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.id.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _statusPill(order.statusLabel),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Placed on ${DateFormat('MMM dd, yyyy • hh:mm a').format(order.orderedAt)}',
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Shipping Updates',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    ..._buildStatusHistory(order.statusHistory),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...order.products.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OrderItemCard(item: item),
              )),
              const SizedBox(height: 14),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shipping Address',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(order.address, style: const TextStyle(color: Color(0xFF334155))),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price Summary',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    _summaryRow('Subtotal (${order.products.length} items)', order.totalPrice),
                    _summaryRow('Shipping Fee', 0, isFree: true),
                    _summaryRow('Tax', order.totalPrice * 0.08),
                    const Divider(height: 24),
                    _summaryRow(
                      'Total Amount',
                      order.totalPrice + (order.totalPrice * 0.08),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildStatusHistory(List<OrderStatusHistoryModel> history) {
    if (history.isEmpty) {
      return const [Text('No status updates available')];
    }

    final sorted = [...history]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return sorted
        .map(
          (item) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF17C3D6), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${item.statusName} • ${DateFormat('MMM dd, hh:mm a').format(item.timestamp)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    )
        .toList();
  }

  Widget _statusPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF9FC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF06B6D4),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value,
      {bool emphasize = false, bool isFree = false}) {
    final color = emphasize ? const Color(0xFF17C3D6) : const Color(0xFF0F172A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF475569),
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            isFree ? 'Free' : '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: isFree ? const Color(0xFF22C55E) : color,
              fontWeight: FontWeight.w700,
              fontSize: emphasize ? 34 : 16,
            ),
          )
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderProductModel item;

  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.images.isNotEmpty ? item.images.first : '',
              width: 84,
              height: 84,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 84,
                height: 84,
                color: const Color(0xFFF1F5F9),
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Color(0xFF17C3D6),
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                    const Spacer(),
                    Text('Qty: ${item.quantity}',
                        style: const TextStyle(color: Color(0xFF64748B))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}