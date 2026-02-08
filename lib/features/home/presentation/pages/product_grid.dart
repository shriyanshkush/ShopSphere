import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Set<String> wishlist;
  final void Function(String productId) onWishlistTap;
  final void Function(String productId) onAddToCart;
  final void Function(String productId) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.wishlist,
    required this.onWishlistTap,
    required this.onAddToCart,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => onProductTap(product.id),
          child: ProductCard(
            product: product,
            isWishlisted: wishlist.contains(product.id),
            onWishlistTap: () => onWishlistTap(product.id),
            onAddToCart: () => onAddToCart(product.id),
          ),
        );
      },
    );
  }
}
