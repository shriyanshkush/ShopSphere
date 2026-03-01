import 'package:shopsphere/features/orders/data/models/order_details_model.dart';
import 'package:shopsphere/features/orders/data/models/order_summary_model.dart';
import 'orders_event.dart';

class OrdersState {
  final bool loadingList;
  final bool loadingDetails;
  final String? error;
  final List<OrderSummaryModel> allOrders;
  final List<OrderSummaryModel> visibleOrders;
  final OrderFilterTab selectedTab;
  final String query;
  final OrderDetailsModel? details;

  const OrdersState({
    required this.loadingList,
    required this.loadingDetails,
    required this.error,
    required this.allOrders,
    required this.visibleOrders,
    required this.selectedTab,
    required this.query,
    required this.details,
  });

  factory OrdersState.initial() => const OrdersState(
        loadingList: false,
        loadingDetails: false,
        error: null,
        allOrders: [],
        visibleOrders: [],
        selectedTab: OrderFilterTab.all,
        query: '',
        details: null,
      );

  OrdersState copyWith({
    bool? loadingList,
    bool? loadingDetails,
    String? error,
    bool clearError = false,
    List<OrderSummaryModel>? allOrders,
    List<OrderSummaryModel>? visibleOrders,
    OrderFilterTab? selectedTab,
    String? query,
    OrderDetailsModel? details,
    bool clearDetails = false,
  }) {
    return OrdersState(
      loadingList: loadingList ?? this.loadingList,
      loadingDetails: loadingDetails ?? this.loadingDetails,
      error: clearError ? null : (error ?? this.error),
      allOrders: allOrders ?? this.allOrders,
      visibleOrders: visibleOrders ?? this.visibleOrders,
      selectedTab: selectedTab ?? this.selectedTab,
      query: query ?? this.query,
      details: clearDetails ? null : (details ?? this.details),
    );
  }
}
