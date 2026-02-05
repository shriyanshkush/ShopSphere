import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_event.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController(text: 'laptops');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(SearchSubmitted(_controller.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: _SearchField(controller: _controller),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    _PillButton(label: 'Filter', icon: Icons.tune),
                    SizedBox(width: 8),
                    _PillButton(label: 'Sort', icon: Icons.keyboard_arrow_down),
                    SizedBox(width: 8),
                    _PillButton(label: 'Brand', icon: Icons.keyboard_arrow_down),
                    SizedBox(width: 8),
                    _PillButton(label: 'Price', icon: Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Over ${state.products.length} results for "${_controller.text}"',
                    style: const TextStyle(fontSize: 18, color: Color(0xFF63708A)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: state.loading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.52,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return _SearchCard(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.productDetail,
                              arguments: product.id,
                            ),
                            image: product.images.isNotEmpty ? product.images.first : '',
                            title: product.name,
                            rating: product.rating,
                            reviews: product.reviews,
                            price: product.price,
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(240, 52)),
                  child: const Text('See more results'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFFF2F5F8), borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        onSubmitted: (v) => context.read<HomeBloc>().add(SearchSubmitted(v)),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF61758F)),
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
              context.read<HomeBloc>().add(SearchSubmitted(''));
            },
            icon: const Icon(Icons.cancel, color: Color(0xFF61758F)),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PillButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5F8),
          borderRadius: BorderRadius.circular(12),
          border: label == 'Filter' ? Border.all(color: const Color(0xFFBDE0FF)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: label == 'Filter' ? Colors.blue : Colors.black, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String title;
  final double rating;
  final int reviews;
  final double price;

  const _SearchCard({
    required this.onTap,
    required this.image,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Colors.grey.shade200)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(image, height: 130, width: double.infinity, fit: BoxFit.cover),
                )
              else
                Container(height: 130, color: Colors.grey.shade200),
              const SizedBox(height: 10),
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text('${rating.toStringAsFixed(1)} ($reviews)'),
                ],
              ),
              const SizedBox(height: 8),
              Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: const Text('Add to Cart')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
