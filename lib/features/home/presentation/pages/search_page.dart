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

  void _updateSearch(String value) {
    context.read<HomeBloc>().add(SearchQueryChanged(value));
    context.read<HomeBloc>().add(SearchSubmitted(value));
  }

  void _applySuggestion(String suggestion) {
    _controller.text = suggestion;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: suggestion.length));
    _updateSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBackToHome ?? () => Navigator.pop(context)),
        title: _SearchField(controller: _controller, onChanged: _updateSearch),
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
              if (state.suggestions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SuggestionList(
                    suggestions: state.suggestions,
                    onSelected: _applySuggestion,
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

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFFF2F5F8), borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF61758F)),
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
              onChanged('');
            },
            icon: const Icon(Icons.cancel, color: Color(0xFF61758F)),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const _SuggestionList({required this.suggestions, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8EF)),
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: suggestions
            .map(
              (item) => ListTile(
                dense: true,
                leading: const Icon(Icons.search, size: 18),
                title: Text(item),
                onTap: () => onSelected(item),
              ),
            )
            .toList(),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(image, height: 130, width: double.infinity, fit: BoxFit.cover),
                )
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
