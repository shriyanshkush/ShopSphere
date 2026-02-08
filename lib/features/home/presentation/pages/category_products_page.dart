import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_bloc.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_event.dart';
import 'package:shopsphere/features/home/presentation/bloc/home_state.dart';

class CategoryProductsPage extends StatefulWidget {
  final String category;
  const CategoryProductsPage({super.key, required this.category});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadCategoryProducts(widget.category));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.products.isEmpty) return const Center(child: Text('No products found'));
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: state.products.length,
            itemBuilder: (_, i) {
              final p = state.products[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.productDetail, arguments: p.id),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: p.images.isEmpty
                            ? Container(color: Colors.grey.shade200)
                            : Image.network(p.images.first, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
