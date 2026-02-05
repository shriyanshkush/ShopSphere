import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/services/api_service.dart';
import '../models/admin_dashboard_model.dart';
import '../models/admin_order_model.dart';


class AdminRemoteDataSource {


  final Dio dio = ApiService().dio;


  Future<AdminDashboardModel> fetchDashboard() async {
    final res = await dio.get('/admin/analytics');
    return AdminDashboardModel.fromJson(res.data);
  }


  Future<List<AdminOrderModel>> fetchOrders() async {
    final res = await dio.get('/admin/get-orders');
    return (res.data['orders'] as List)
        .map((e) => AdminOrderModel.fromJson(e))
        .toList();
  }


  Future<void> updateOrderStatus(String id, int status) async {
    await dio.post('/admin/change-order-status', data: {
      'id': id,
      'status': status,
    });
  }

  Future<List<dynamic>> getInventory(
      String? status,
      String? category,
      String? search,
      ) async {
    final query = <String, String>{};

    if (status != null && status.isNotEmpty) query['status'] = status;
    if (category != null && category.isNotEmpty) query['category'] = category;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final res = await dio.get('/admin/inventory',queryParameters: query);
    return List<Map<String, dynamic>>.from(res.data);
  }


  Future<void> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    required int quantity,
    required List<String> images,
  }) async {
    await dio.post('/admin/add-product', data: {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'quantity': quantity,
      'images': images,
    });
  }

  Future<void> updateProduct({
    required String id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? quantity,
    List<String>? images,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category;
    if (price != null) data['price'] = price;
    if (quantity != null) data['quantity'] = quantity;
    if (images != null) data['images'] = images;

    await dio.put('/admin/update-product/$id', data: data);
  }




  Future<List<String>> uploadImagesPublic({
    required List<File> images,
  }) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;


    final dio = Dio();
    List<String> urls = [];

    for (final file in images) {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        'upload_preset': uploadPreset,
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/upload',
        data: formData,
        options: Options(headers: {
          'X-Requested-With': 'XMLHttpRequest',
        }),
      );

      if (response.statusCode == 200) {
        urls.add(response.data['secure_url']);
      } else {
        throw Exception(response.data['error']['message']);
      }
    }

    return urls;
  }



}