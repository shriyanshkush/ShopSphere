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
  int selectedChip = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminBloc>().add(LoadInventory());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF19C8DC),
        elevation: 0,
        titleSpacing: 0,
        title: const Text('Inventory Management', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.white)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white))],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF19C8DC),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(value: context.read<AdminBloc>(), child: const AdminAddEditProductPage()),
            ),
          );
          if (!mounted) return;
          context.read<AdminBloc>().add(LoadInventory());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => context.read<AdminBloc>().add(LoadInventory(search: v)),
              decoration: InputDecoration(
                hintText: 'Search by product name or SKU',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF808A9A)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip('All Items', 0),
                _chip('Low Stock', 1),
                _chip('Categories', 2, trailing: const Icon(Icons.keyboard_arrow_down, size: 18)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: Text('Product Catalog', style: TextStyle(fontSize: 36 / 2, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminError) {
                  return Center(child: Text(state.message));
                }
                if (state is! AdminInventoryLoaded) {
                  return const SizedBox.shrink();
                }
                if (state.items.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => InventoryCard(item: state.items[i]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _chip(String label, int idx, {Widget? trailing}) {
    final selected = selectedChip == idx;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Row(mainAxisSize: MainAxisSize.min, children: [Text(label), if (trailing != null) trailing]),
        selected: selected,
        showCheckmark: false,
        side: BorderSide(color: selected ? const Color(0xFF7CD9E6) : const Color(0xFFD0D5DD)),
        labelStyle: TextStyle(color: selected ? Colors.black : const Color(0xFF344054), fontWeight: FontWeight.w500),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFBDECF2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        onSelected: (_) {
          setState(() => selectedChip = idx);
          if (idx == 1) {
            context.read<AdminBloc>().add(LoadInventory(status: 'low'));
          } else {
            context.read<AdminBloc>().add(LoadInventory());
          }
        },
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final int qty = item['quantity'] ?? 0;
    final int stockLevel = item['stockLevel'] ?? 0;
    final bool isLow = stockLevel < 20;
    final bool isMedium = stockLevel >= 20 && stockLevel < 50;
    final Color statusColor = isLow ? const Color(0xFFE11D48) : (isMedium ? const Color(0xFFF97316) : const Color(0xFF16A34A));
    final String status = item['stockStatus'] ?? (isLow ? 'Low Stock' : (isMedium ? 'Medium' : 'Good'));
    final controller = TextEditingController(text: qty.toString());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isLow ? const Color(0xFFF3CCD6) : const Color(0xFFE6E8EC), width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _ProductImage(item['image']),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(item['name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                if (isLow)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFFFE9ED), borderRadius: BorderRadius.circular(8)),
                    child: const Text('ALERT', style: TextStyle(color: Color(0xFFD92D20), fontWeight: FontWeight.w700)),
                  )
              ]),
              const SizedBox(height: 2),
              Text('${item['category']} • SKU: ${item['sku']}', style: const TextStyle(color: Color(0xFF667084), fontSize: 14)),
            ]),
          ),
        ]),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Stock Level: $stockLevel%', style: const TextStyle(fontSize: 18 / 1.4, color: Color(0xFF344054))),
          Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 30 / 2)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            minHeight: 9,
            value: stockLevel / 100,
            backgroundColor: const Color(0xFFE9ECF0),
            valueColor: AlwaysStoppedAnimation(statusColor),
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                filled: true,
                fillColor: const Color(0xFFF2F4F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD0D5DD))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD0D5DD))),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19C8DC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () {
                final newQty = int.tryParse(controller.text);
                if (newQty == null || newQty < 0) return;
                context.read<AdminBloc>().add(UpdateProduct(id: item['id'], quantity: newQty));
                context.read<AdminBloc>().add(LoadInventory());
              },
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('Update', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
            ),
          ),
        ])
      ]),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  const _ProductImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl ?? '',
        width: 84,
        height: 84,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 84,
          height: 84,
          color: const Color(0xFFE5E7EB),
          child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF667084)),
        ),
      ),
    );
  }
}
