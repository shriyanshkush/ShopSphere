import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/orders/domain/repositories/orders_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';
import 'package:shopsphere/features/orders/data/models/order_summary_model.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository repo;

  OrdersBloc(this.repo) : super(OrdersState.initial()) {
    on<LoadOrders>(_loadOrders);
    on<SearchOrders>(_searchOrders);
    on<FilterOrdersByTab>(_filterOrders);
    on<LoadOrderDetails>(_loadOrderDetails);
  }

  Future<void> _loadOrders(LoadOrders event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(loadingList: true, clearError: true));
    try {
      final orders = await repo.fetchMyOrders();
      final visible = _applyFilters(
        orders: orders,
        tab: state.selectedTab,
        query: state.query,
      );
      emit(state.copyWith(
        loadingList: false,
        allOrders: orders,
        visibleOrders: visible,
      ));
    } catch (_) {
      emit(state.copyWith(loadingList: false, error: 'Failed to load orders'));
    }
  }

  void _searchOrders(SearchOrders event, Emitter<OrdersState> emit) {
    final visible = _applyFilters(
      orders: state.allOrders,
      tab: state.selectedTab,
      query: event.query,
    );
    emit(state.copyWith(query: event.query, visibleOrders: visible));
  }

  void _filterOrders(FilterOrdersByTab event, Emitter<OrdersState> emit) {
    final visible = _applyFilters(
      orders: state.allOrders,
      tab: event.tab,
      query: state.query,
    );
    emit(state.copyWith(selectedTab: event.tab, visibleOrders: visible));
  }

  Future<void> _loadOrderDetails(LoadOrderDetails event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(loadingDetails: true, clearError: true, clearDetails: true));
    try {
      final details = await repo.fetchOrderDetails(event.orderId);
      emit(state.copyWith(loadingDetails: false, details: details));
    } catch (_) {
      emit(state.copyWith(loadingDetails: false, error: 'Failed to load order details'));
    }
  }

  List<OrderSummaryModel> _applyFilters({
    required List<OrderSummaryModel> orders,
    required OrderFilterTab tab,
    required String query,
  }) {
    return orders.where((order) {
      final statusMatch = switch (tab) {
        OrderFilterTab.all => true,
        OrderFilterTab.ongoing => order.status >= 0 && order.status <= 3,
        OrderFilterTab.completed => order.status == 4,
        OrderFilterTab.cancelled => order.status == 5,
      };

      final q = query.trim().toLowerCase();
      final queryMatch = q.isEmpty ||
          order.orderCode.toLowerCase().contains(q) ||
          order.firstItemName.toLowerCase().contains(q);

      return statusMatch && queryMatch;
    }).toList();
  }
}
