import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/product_detail/data/models/product_detail_model.dart';
import 'package:shopsphere/features/product_detail/presentation/pages/review_list_page.dart';
import 'package:shopsphere/features/product_detail/presentation/pages/write_review_page.dart';

import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';
import '../blocs/review/ReviewBloc.dart';
import '../blocs/review/ReviewEvent.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        /// 🔑 Load once
        if (!state.loading && state.product == null) {
          context
              .read<ProductDetailBloc>()
              .add(LoadProductDetail(productId));
        }

        if (state.loading || state.product == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final product = state.product!;

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _BottomActionBar(
            onAddToCart: () {
              context.read<ProductDetailBloc>().add(AddToCart());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart')),
              );
            },
            onBuyNow: () {
              context.read<ProductDetailBloc>().add(AddToCart());
              Navigator.pushNamed(context, Routes.checkoutAddress);
            },
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<ProductDetailBloc>()
                    .add(LoadProductDetail(productId));
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(
                      isWishlisted: state.isWishlisted,
                      onWishlist: () => context.read<ProductDetailBloc>().add(ToggleWishlist()),
                    ),
                    _ImageCarousel(images: product.images),
                    _ProductInfo(product: product),
                    _ProductDescription(description: product.description),
                    _ReviewSection(
                      rating: product.rating,
                      reviewsCount: product.reviews,
                      productDetailModel: product,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class _TopBar extends StatelessWidget {
  final VoidCallback onWishlist;
  final bool isWishlisted;
  const _TopBar({required this.onWishlist, required this.isWishlisted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border),
            color: isWishlisted ? Colors.redAccent : null,
            onPressed: onWishlist,
          ),
        ],
      ),
    );
  }
}



class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  const _ImageCarousel({required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey.shade100,
          ),
          child: PageView.builder(
            itemCount: images.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.all(16),
              child: Image.network(
                images[i],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class _ProductInfo extends StatelessWidget {
  final dynamic product;
  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STORE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text('${product.rating}'),
              const SizedBox(width: 6),
              Text(
                '(${product.reviews} reviews)',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '\$${product.price}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                product.inStock ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color: product.inStock ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  final String description;
  const _ProductDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 6),
          const Text(
            'Read More',
            style: TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


class _ReviewSection extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  final ProductDetailModel productDetailModel;

  const _ReviewSection({
    required this.rating,
    required this.reviewsCount,
    required this.productDetailModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              OutlinedButton.icon(
                onPressed: () {
                  final productDetailBloc =
                  context.read<ProductDetailBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            ReviewBloc(productDetailBloc.repo),
                        child: WriteReviewPage(
                          productId: productDetailModel.id,
                          productName: productDetailModel.name,
                          productSubtitle:"",
                          productImage: productDetailModel.images.first,
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.cyan,
                ),
                label: const Text(
                  'Write a Review',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.cyan),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '$reviewsCount verified reviews',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => ReviewBloc(
                      context.read<ProductDetailBloc>().repo,
                    )..add(LoadReviews(productDetailModel.id)),
                    child: ReviewListPage(
                      productId: productDetailModel.id,
                      productName: productDetailModel.name,
                      averageRating: productDetailModel.rating,
                      totalReviews: reviewsCount,
                    ),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Text(
              'View All $reviewsCount Reviews',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),


        ],
      ),
    );
  }
}


class _BottomActionBar extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  const _BottomActionBar({required this.onAddToCart, required this.onBuyNow});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onAddToCart,
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                onPressed: onBuyNow,
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
