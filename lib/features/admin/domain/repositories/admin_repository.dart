import 'dart:io';

abstract class AdminRepository {
  Future fetchDashboard();
  Future fetchOrders();
  Future fetchBestSellingProducts();
  Future fetchLowInventoryAlerts();
  Future updateOrderStatus(String id, int status);
  // ✅ ADD THIS
  Future<List<dynamic>> fetchInventory({
    String? status,
    String? category,
    String? search,
  });



  /// ✅ FIXED: Add product (FULL BACKEND CONTRACT)
  Future<void> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    required int quantity,
    required List<String> images,
  });

  /// ✅ FIXED: Update product
  Future<void> updateProduct({
    required String id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? quantity,
    List<String>? images,
  });


  Future<List<String>> uploadImages(List<File> images);

}
