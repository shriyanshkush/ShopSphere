import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_event.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadCart());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (_, state) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            return Column(
              children: [
                _CartHeader(count: state.cartCount),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    children: [
                      ...state.cartItems.map(
                        (raw) {
                          final item = raw as Map<String, dynamic>;
                          final product = item['product'] as Map<String, dynamic>? ?? {};
                          final images = (product['images'] as List? ?? []);
                          final productId = product['_id']?.toString() ?? '';
                          return _CartItemCard(
                            title: product['name']?.toString() ?? 'Product',
                            subtitle: product['brand']?.toString() ?? (product['category']?.toString() ?? 'In stock'),
                            price: (product['price'] as num?)?.toDouble() ?? 0,
                            quantity: (item['quantity'] as num?)?.toInt() ?? 1,
                            imageUrl: images.isNotEmpty ? images.first.toString() : '',
                            onAdd: productId.isEmpty
                                ? null
                                : () => context.read<HomeBloc>().add(AddToCart(productId)),
                            onRemove: productId.isEmpty
                                ? null
                                : () => context.read<HomeBloc>().add(RemoveFromCart(productId)),
                          );
                        },
                      ).toList(),
                      const _PromoCodeCard(),
                      _PriceDetailsCard(total: state.cartTotal),
                      const SizedBox(height: 16),
                      _CheckoutButton(total: state.cartTotal),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  final int count;
  const _CartHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF18C4D9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0x331FFFFFF),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Text(
            'Shopping Cart ($count)',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          const CircleAvatar(
            backgroundColor: Color(0x331FFFFFF),
            child: Icon(Icons.more_horiz, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double price;
  final int quantity;
  final String imageUrl;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const _CartItemCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: imageUrl.isEmpty
                ? Container(width: 72, height: 72, color: Colors.grey.shade200)
                : Image.network(imageUrl, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 6),
                Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF18C4D9), fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 6),
                Text(subtitle.toUpperCase(), style: const TextStyle(color: Color(0xFF97A3B6), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          _QuantityControl(quantity: quantity, onAdd: onAdd, onRemove: onRemove),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  const _QuantityControl({required this.quantity, this.onAdd, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _QtyButton(icon: Icons.remove, onTap: onRemove),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          _QtyButton(icon: Icons.add, onTap: onAdd),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.white,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16, color: const Color(0xFF2C3852)),
        onPressed: onTap,
      ),
    );
  }
}

class _PromoCodeCard extends StatelessWidget {
  const _PromoCodeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.sell_outlined, color: Color(0xFF18C4D9)),
          const SizedBox(width: 10),
          const Expanded(child: Text('Add Promo Code', style: TextStyle(fontWeight: FontWeight.w600))),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(backgroundColor: const Color(0xFFE6F7F8)),
            child: const Text('Apply', style: TextStyle(color: Color(0xFF18C4D9), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _PriceDetailsCard extends StatelessWidget {
  final double total;
  const _PriceDetailsCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 12),
          _PriceRow(label: 'Subtotal', value: '\$${total.toStringAsFixed(2)}'),
          const _PriceRow(label: 'Shipping Fee', value: 'FREE', valueColor: Color(0xFF10B981)),
          const _PriceRow(label: 'Tax', value: '\$0.00'),
          const Divider(height: 24),
          _PriceRow(label: 'Total Amount', value: '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
      fontSize: isTotal ? 18 : 16,
      color: valueColor,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF63708A))),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final double total;
  const _CheckoutButton({required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: total <= 0 ? null : () => Navigator.pushNamed(context, Routes.checkoutAddress),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF18C4D9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Proceed to Checkout  →', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
