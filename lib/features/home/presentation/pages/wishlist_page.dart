import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/data/models/product_model.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_event.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_state.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadWishlistProducts());
    });
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Wishlist'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Color(0xFF18C4D9))),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          final items = state.wishlistProducts
              .where((item) => item.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();
          if (items.isEmpty) {
            return const Center(child: Text('Your wishlist is empty'));
          }
          final total = items.fold<double>(0, (sum, item) => sum + item.price);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: const Color(0xFFF2F5F8), borderRadius: BorderRadius.circular(14)),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Color(0xFF61758F)),
                      hintText: 'Search your wishlist...',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, i) {
                    final p = items[i];
                    return _WishlistCard(
                      product: p,
                      onTap: () => Navigator.pushNamed(context, Routes.productDetail, arguments: p.id),
                      onMoveToCart: () => context.read<HomeBloc>().add(AddToCart(p.id)),
                      onToggleWishlist: () => context.read<HomeBloc>().add(ToggleWishlist(p.id)),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, -4)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Wishlist Value', style: TextStyle(color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD8F6FA),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        for (final item in items) {
                          context.read<HomeBloc>().add(AddToCart(item.id));
                        }
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF18C4D9)),
                      label: const Text('Move All to Cart', style: TextStyle(color: Color(0xFF18C4D9), fontWeight: FontWeight.w700)),
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
}

class _WishlistCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onMoveToCart;
  final VoidCallback onToggleWishlist;

  const _WishlistCard({
    required this.product,
    required this.onTap,
    required this.onMoveToCart,
    required this.onToggleWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: product.images.isEmpty
                  ? Container(width: 84, height: 84, color: const Color(0xFFF2F5F8))
                  : Image.network(product.images.first, width: 84, height: 84, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF18C4D9), fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text('${product.rating.toStringAsFixed(1)} (${product.reviews})', style: const TextStyle(color: Color(0xFF64748B))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18C4D9),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: onMoveToCart,
                      icon: const Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                      label: const Text('Move to Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: onToggleWishlist,
              icon: const Icon(Icons.favorite, color: Color(0xFF18C4D9)),
            ),
          ],
        ),
      ),
    );
  }
}
