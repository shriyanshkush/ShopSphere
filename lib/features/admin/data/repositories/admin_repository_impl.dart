import 'dart:io';

import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';


class AdminRepositoryImpl implements AdminRepository {
  final _remote = AdminRemoteDataSource();


  @override
  Future fetchDashboard() => _remote.fetchDashboard();


  @override
  Future fetchOrders() => _remote.fetchOrders();



  @override
  Future fetchBestSellingProducts() => _remote.fetchBestSellingProducts();

  @override
  Future fetchLowInventoryAlerts() => _remote.fetchLowInventoryAlerts();

  @override
  Future updateOrderStatus(String id, int status) =>
      _remote.updateOrderStatus(id, status);

  @override
  Future<List<dynamic>> fetchInventory({
    String? status,
    String? category,
    String? search,
}) async {

    final response = await _remote.getInventory(status,category,search);
    return response;
  }

  @override
  Future<void> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    required int quantity,
    required List<String> images,
  }) async {
    await _remote.addProduct(
      name: name,
      description: description,
      category: category,
      price: price,
      quantity: quantity,
      images: images,
    );
  }

  @override
  Future<void> updateProduct({
    required String id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? quantity,
    List<String>? images,
  }) async {
    await _remote.updateProduct(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      quantity: quantity,
      images: images,
    );
  }


  @override
  Future<List<String>> uploadImages(List<File> images) {
    return _remote.uploadImagesPublic(images: images);
  }



}