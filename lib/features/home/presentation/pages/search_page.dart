import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_event.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_state.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const SearchPage({super.key, this.onBackToHome});

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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBackToHome),
        title: _SearchField(controller: _controller),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, Routes.cart),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _openFilter(context, state),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F5F8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBDE0FF)),
                          ),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Filter', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)), SizedBox(width: 6), Icon(Icons.tune, size: 18)]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _SortPill(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Over ${state.products.length} results for "${_controller.text}"', style: const TextStyle(fontSize: 18, color: Color(0xFF63708A))),
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
                            onTap: () => Navigator.pushNamed(context, Routes.productDetail, arguments: product.id),
                            onAddToCart: () => context.read<HomeBloc>().add(AddToCart(product.id)),
                            image: product.images.isNotEmpty ? product.images.first : '',
                            title: product.name,
                            rating: product.rating,
                            reviews: product.reviews,
                            price: product.price,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openFilter(BuildContext context, HomeState state) async {
    String selectedCategory = state.selectedCategory;
    double minPrice = state.minPrice;
    double maxPrice = state.maxPrice;
    double minRating = state.minRating;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSt) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Container(width: 80, height: 8, decoration: BoxDecoration(color: const Color(0xFFE8F2F2), borderRadius: BorderRadius.circular(20)))),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Filters', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close))]),
                      const SizedBox(height: 12),
                      const Text('Category', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final c in (state.categories.isEmpty ? ['Mobiles','Laptops','Audio','Watches'] : state.categories))
                            ChoiceChip(
                              label: Text(c),
                              selected: selectedCategory == c,
                              onSelected: (_) => setSt(() => selectedCategory = c),
                              selectedColor: Colors.cyan,
                              labelStyle: TextStyle(color: selectedCategory == c ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
                            )
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text('Price Range   \$${minPrice.toInt()} - \$${maxPrice.toInt()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      RangeSlider(
                        values: RangeValues(minPrice, maxPrice),
                        min: 0,
                        max: 2000,
                        onChanged: (v) => setSt(() {
                          minPrice = v.start;
                          maxPrice = v.end;
                        }),
                      ),
                      const SizedBox(height: 8),
                      const Text('Rating', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      Slider(
                        value: minRating,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: minRating.toStringAsFixed(0),
                        onChanged: (v) => setSt(() => minRating = v),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setSt(() {
                                selectedCategory = '';
                                minPrice = 120;
                                maxPrice = 850;
                                minRating = 0;
                              }),
                              child: const Text('Clear All'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<HomeBloc>().add(
                                      ApplyFilters(
                                        category: selectedCategory,
                                        minPrice: minPrice,
                                        maxPrice: maxPrice,
                                        minRating: minRating,
                                      ),
                                    );
                                Navigator.pop(ctx);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                              child: Text('Apply Filters (${state.products.length})'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SortPill extends StatelessWidget {
  const _SortPill();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: const Color(0xFFF2F5F8), borderRadius: BorderRadius.circular(12)),
        child: PopupMenuButton<String>(
          onSelected: (v) => context.read<HomeBloc>().add(ApplyFilters(sort: v)),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'price_asc', child: Text('Price Low to High')),
            PopupMenuItem(value: 'price_desc', child: Text('Price High to Low')),
            PopupMenuItem(value: 'rating_desc', child: Text('Top Rated')),
          ],
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Sort', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(width: 6), Icon(Icons.keyboard_arrow_down)]),
        ),
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
        onChanged: (v) => context.read<HomeBloc>().add(SearchQueryChanged(v)),
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

class _SearchCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final String image;
  final String title;
  final double rating;
  final int reviews;
  final double price;

  const _SearchCard({
    required this.onTap,
    required this.onAddToCart,
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
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(image, height: 130, width: double.infinity, fit: BoxFit.cover))
              else
                Container(height: 130, color: Colors.grey.shade200),
              const SizedBox(height: 10),
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(children: [const Icon(Icons.star, color: Colors.orange, size: 16), const SizedBox(width: 4), Text('${rating.toStringAsFixed(1)} ($reviews)')]),
              const SizedBox(height: 8),
              Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const Spacer(),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onAddToCart, child: const Text('Add to Cart'))),
            ],
          ),
        ),
      ),
    );
  }
}
