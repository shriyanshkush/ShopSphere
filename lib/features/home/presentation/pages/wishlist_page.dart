import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_event.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_state.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadWishlistProducts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          final items = state.wishlistProducts;
          if (items.isEmpty) return const Center(child: Text('Your wishlist is empty'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return ListTile(
                onTap: () => Navigator.pushNamed(context, Routes.productDetail, arguments: p.id),
                leading: p.images.isEmpty
                    ? const SizedBox(width: 56, height: 56)
                    : Image.network(p.images.first, width: 56, height: 56, fit: BoxFit.cover),
                title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () => context.read<HomeBloc>().add(AddToCart(p.id)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => context.read<HomeBloc>().add(ToggleWishlist(p.id)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
