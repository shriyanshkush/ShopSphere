import 'product_model.dart';

class HomeResponse {
  final List<Map<String, dynamic>> categories;
  final List<ProductModel> products;

  HomeResponse({
    required this.categories,
    required this.products,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      categories: List<Map<String, dynamic>>.from(json['categories']),
      products: (json['products'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
    );
  }
}
