import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          if (state.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (_, i) {
                    final item = state.cartItems[i] as Map<String, dynamic>;
                    final product = item['product'] as Map<String, dynamic>? ?? {};
                    final images = (product['images'] as List? ?? []);
                    return ListTile(
                      leading: images.isEmpty
                          ? const SizedBox(width: 56, height: 56)
                          : Image.network(images.first.toString(), width: 56, height: 56, fit: BoxFit.cover),
                      title: Text(product['name']?.toString() ?? 'Product'),
                      subtitle: Text('Qty: ${item['quantity']}'),
                      trailing: Text('\$${(((product['price'] as num?)?.toDouble() ?? 0) * ((item['quantity'] as num?)?.toDouble() ?? 0)).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE4EAF2)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text('\$${state.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
