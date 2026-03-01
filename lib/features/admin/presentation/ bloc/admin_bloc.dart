import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/admin/data/repositories/admin_repository_impl.dart';
import 'admin_event.dart';
import 'admin_state.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepositoryImpl repo;

  AdminBloc(this.repo) : super(AdminInitial()) {
    on<LoadDashboard>((_, emit) async {
      emit(AdminLoading());
      try {
        final data = await repo.fetchDashboard();
        emit(AdminDashboardLoaded(data));
      } catch (_) {
        emit(AdminError('Failed to load dashboard'));
      }
    });

    on<LoadOrders>((_, emit) async {
      emit(AdminLoading());
      try {
        final data = await repo.fetchOrders();
        emit(AdminOrdersLoaded(data));
      } catch (_) {
        emit(AdminError('Failed to load orders'));
      }
    });

    on<LoadBestSellingProducts>((_, emit) async {
      emit(AdminLoading());
      try {
        final data = await repo.fetchBestSellingProducts();
        emit(AdminBestSellingLoaded(data));
      } catch (_) {
        emit(AdminError('Failed to load best-selling products'));
      }
    });

    on<LoadLowInventoryAlerts>((_, emit) async {
      emit(AdminLoading());
      try {
        final data = await repo.fetchLowInventoryAlerts();
        emit(AdminLowInventoryAlertsLoaded(data));
      } catch (_) {
        emit(AdminError('Failed to load inventory alerts'));
      }
    });

    on<UpdateOrderStatus>((e, emit) async {
      await repo.updateOrderStatus(e.id, e.status);
      add(LoadOrders());
    });

    on<LoadInventory>((e, emit) async {
      emit(AdminLoading());
      try {
        final data = await repo.fetchInventory(
          status: e.status,
          category: e.category,
          search: e.search,
        );
        emit(AdminInventoryLoaded(data));
      } catch (_) {
        emit(AdminError('Failed to load inventory'));
      }
    });

    on<AddProduct>((e, emit) async {
      emit(AdminProductSaving());
      try {
        await repo.addProduct(
          name: e.name,
          description: e.description,
          category: e.category,
          price: e.price,
          quantity: e.quantity,
          images: e.images,
        );
        emit(AdminProductSaved());
      } catch (e) {
        emit(AdminProductError('Failed to add product'));
      }
    });

    on<UpdateProduct>((e, emit) async {
      emit(AdminProductSaving());
      try {
        await repo.updateProduct(
          id: e.id,
          name: e.name,
          description: e.description,
          category: e.category,
          price: e.price,
          quantity: e.quantity,
          images: e.images,
        );

        emit(AdminProductSaved());
      } catch (_) {
        emit(AdminProductError('Failed to update product'));
      }
    });
  }
}
