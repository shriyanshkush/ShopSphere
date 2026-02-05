import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';
import 'package:shopsphere/features/admin/presentation/pages/admin_add_edit_product_page.dart';

class AdminInventoryPage extends StatefulWidget {
  const AdminInventoryPage({super.key});

  @override
  State<AdminInventoryPage> createState() => _AdminInventoryPageState();
}

class _AdminInventoryPageState extends State<AdminInventoryPage> {
  @override
  void initState() {
    super.initState();

    /// SAFER: dispatch after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminBloc>().add(LoadInventory());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AdminBloc>(),
                child: const AdminAddEditProductPage(),
              ),
            ),
          );

          // 🔄 Refresh inventory after coming back
          context.read<AdminBloc>().add(LoadInventory());
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminInventoryLoaded) {
            final items = state.items;

            if (items.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                return InventoryCard(item: items[i]);
              },
            );
          }

          if (state is AdminError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal,
      title: const Text('Inventory'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // TODO: Open bottom sheet for filters
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            onChanged: (value) {
              context.read<AdminBloc>().add(
                LoadInventory(search: value),
              );
            },
            decoration: InputDecoration(
              hintText: "Search by product name or SKU",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================
   INVENTORY CARD
========================= */

class InventoryCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final int qty = item['quantity'] ?? 0;
    final int stockLevel = item['stockLevel'] ?? 0;
    final String status = item['stockStatus'] ?? 'Good';

    final TextEditingController qtyController =
    TextEditingController(text: qty.toString());

    final bool isLow = stockLevel < 20;
    final bool isMedium = stockLevel >= 20 && stockLevel < 50;

    final Color statusColor =
    isLow ? Colors.red : isMedium ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isLow ? Border.all(color: Colors.red.shade200) : null,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ─── TOP ROW ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(item['image']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isLow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'ALERT',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['category']} • SKU: ${item['sku']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          /// ─── STOCK INFO ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock Level: $stockLevel%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// ─── PROGRESS BAR ───
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: stockLevel / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),

          const SizedBox(height: 16),

          /// ─── UPDATE ROW ───
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final newQty = int.tryParse(qtyController.text);
                  if (newQty == null || newQty < 0) return;

                  context.read<AdminBloc>().add(
                    UpdateProduct(
                      id: item['id'],
                      quantity: newQty,
                    ),
                  );

                  context.read<AdminBloc>().add(LoadInventory());
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* =========================
   PRODUCT IMAGE
========================= */

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl ?? '',
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 56,
            height: 56,
            color: Colors.grey.shade200,
            child: const Icon(Icons.inventory_2),
          );
        },
      ),
    );
  }
}
