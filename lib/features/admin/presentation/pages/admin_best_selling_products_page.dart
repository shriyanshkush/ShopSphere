import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/data/models/admin_dashboard_model.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';

class AdminBestSellingProductsPage extends StatefulWidget {
  const AdminBestSellingProductsPage({super.key});

  @override
  State<AdminBestSellingProductsPage> createState() => _AdminBestSellingProductsPageState();
}

class _AdminBestSellingProductsPageState extends State<AdminBestSellingProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadBestSellingProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Best Selling Products')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) return const Center(child: CircularProgressIndicator());
          if (state is AdminError) return Center(child: Text(state.message));
          if (state is! AdminBestSellingLoaded) return const SizedBox.shrink();

          final products = List<BestSellingProductModel>.from(state.products);
          if (products.isEmpty) return const Center(child: Text('No best-selling products found'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final item = products[i];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                tileColor: Colors.white,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEFF4F8),
                  backgroundImage: item.image != null ? NetworkImage(item.image!) : null,
                  child: item.image == null ? const Icon(Icons.shopping_bag_outlined) : null,
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(item.category),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${item.soldCount} sales', style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF667084))),
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
