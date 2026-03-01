import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/data/models/admin_dashboard_model.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_bloc.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_event.dart';
import 'package:shopsphere/features/admin/presentation/%20bloc/admin_state.dart';

class AdminLowInventoryAlertsPage extends StatefulWidget {
  const AdminLowInventoryAlertsPage({super.key});

  @override
  State<AdminLowInventoryAlertsPage> createState() => _AdminLowInventoryAlertsPageState();
}

class _AdminLowInventoryAlertsPageState extends State<AdminLowInventoryAlertsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadLowInventoryAlerts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Low Inventory Alerts')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) return const Center(child: CircularProgressIndicator());
          if (state is AdminError) return Center(child: Text(state.message));
          if (state is! AdminLowInventoryAlertsLoaded) return const SizedBox.shrink();

          final alerts = List<InventoryAlertModel>.from(state.alerts);
          if (alerts.isEmpty) return const Center(child: Text('No low inventory alerts found'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final item = alerts[i];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFF9D4DC)),
                ),
                tileColor: const Color(0xFFFFF8FA),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFFFE9ED),
                  child: const Icon(Icons.priority_high_rounded, color: Color(0xFFE83A57)),
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('SKU: ${item.sku ?? '--'}'),
                trailing: Text('${item.quantity} left', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFE83A57))),
              );
            },
          );
        },
      ),
    );
  }
}
