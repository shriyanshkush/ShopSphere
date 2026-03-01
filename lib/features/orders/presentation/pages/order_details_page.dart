import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopsphere/features/orders/data/models/order_details_model.dart';
import 'package:shopsphere/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shopsphere/features/orders/presentation/bloc/orders_event.dart';
import 'package:shopsphere/features/orders/presentation/bloc/orders_state.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrderDetails(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (_, state) {
            if (state.loadingDetails) {
              return const Center(child: CircularProgressIndicator());
            }
            final details = state.details;
            if (details == null) {
              return const Center(child: Text('Unable to load order details'));
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order Details', style: TextStyle(fontSize: 32 / 1.4, fontWeight: FontWeight.w800)),
                          Text('Order ${details.orderCode}', style: const TextStyle(color: Color(0xFF72849E))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFE6FAFD), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFF9EEBF3))),
                      child: Text(details.statusLabel, style: const TextStyle(color: Color(0xFF07BFD0), fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _shippingUpdatesCard(details),
                const SizedBox(height: 22),
                Text('Order Items (${details.items.length})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 31 / 1.4)),
                const SizedBox(height: 10),
                ...details.items.map(_itemCard),
                const SizedBox(height: 12),
                _sectionCard(
                  icon: Icons.location_on,
                  title: 'Shipping Address',
                  child: Text(details.address.replaceAll(',', '\n'), style: const TextStyle(color: Color(0xFF3D4F6A), height: 1.5)),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  icon: Icons.credit_card,
                  title: 'Payment Method',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(8)),
                        child: Text(details.paymentMethod.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                      ),
                      const SizedBox(width: 12),
                      Text(details.paymentStatus, style: const TextStyle(color: Color(0xFF3D4F6A))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _priceSummary(details),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.receipt_long, color: Color(0xFF00C7DE)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Color(0xFF9EEBF3)),
                  ),
                  label: const Text('Download Invoice', style: TextStyle(color: Color(0xFF00C7DE), fontSize: 24 / 1.3, fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _shippingUpdatesCard(OrderDetailsModel details) {
    final updatedAt = DateFormat('MMM d').format(details.orderedAt);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9EDF3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shipping Updates', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22 / 1.3)),
              Text('Updated $updatedAt', style: const TextStyle(color: Color(0xFF72849E))),
            ],
          ),
          const SizedBox(height: 14),
          const Row(children: [Icon(Icons.local_shipping, color: Color(0xFF08C3D5)), SizedBox(width: 10), Text('In Transit', style: TextStyle(fontSize: 30 / 1.5, fontWeight: FontWeight.w700))]),
          const Padding(
            padding: EdgeInsets.only(left: 34, top: 4, bottom: 12),
            child: Text('Package has left the regional facility', style: TextStyle(color: Color(0xFF72849E))),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1CCBDE), foregroundColor: Colors.white, minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Track Order', style: TextStyle(fontSize: 24 / 1.4, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(OrderLineItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9EDF3))),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.image.isNotEmpty
                ? Image.network(item.image, width: 88, height: 88, fit: BoxFit.cover)
                : Container(width: 88, height: 88, color: const Color(0xFFEFF3F8), child: const Icon(Icons.image_outlined)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 26 / 1.45)),
                const SizedBox(height: 2),
                Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF72849E))),
                const SizedBox(height: 8),
                Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF00C7DE), fontWeight: FontWeight.w800, fontSize: 24 / 1.2)),
              ],
            ),
          ),
          Text('Qty: ${item.quantity}', style: const TextStyle(color: Color(0xFF72849E), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _sectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9EDF3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: const Color(0xFF09C2D4), size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22 / 1.3))]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }

  Widget _priceSummary(OrderDetailsModel details) {
    String f(double n) => '\$${n.toStringAsFixed(2)}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9EDF3))),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text('Price Summary', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22 / 1.3))),
          const SizedBox(height: 12),
          _row('Subtotal (${details.items.length} items)', f(details.subtotal)),
          _row('Shipping Fee', details.shippingFee == 0 ? 'Free' : f(details.shippingFee), valueColor: details.shippingFee == 0 ? const Color(0xFF1BBE7A) : null),
          _row('Tax', f(details.tax)),
          const Divider(height: 22),
          _row('Total Amount', f(details.total), bold: true, valueColor: const Color(0xFF00C7DE)),
        ],
      ),
    );
  }

  Widget _row(String l, String r, {bool bold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: TextStyle(color: const Color(0xFF556985), fontWeight: bold ? FontWeight.w700 : FontWeight.w500, fontSize: 16)),
          Text(r, style: TextStyle(color: valueColor ?? const Color(0xFF131722), fontWeight: bold ? FontWeight.w800 : FontWeight.w600, fontSize: bold ? 31 / 1.45 : 17)),
        ],
      ),
    );
  }
}
