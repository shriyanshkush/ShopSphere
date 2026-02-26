import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/review_model.dart';
import '../blocs/review/ReviewBloc.dart';
import '../blocs/review/ReviewEvent.dart';
import '../blocs/review/ReviewState.dart';

class ReviewListPage extends StatelessWidget {
  final String productId;
  final String productName;
  final double averageRating;
  final int totalReviews;

  const ReviewListPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer Reviews'),
            Text(
              productName,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state.loading && state.reviews.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.reviews.isEmpty) {
            return Center(child: Text(state.error!));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _RatingSummary(
                averageRating: averageRating,
                totalReviews: totalReviews,
              ),
              const SizedBox(height: 16),
              _FilterRow(),
              const SizedBox(height: 24),

              /// REVIEWS
              ...state.reviews.map((r) => _ReviewCard(review: r)),

              const SizedBox(height: 24),

              OutlinedButton(
                onPressed: () {
                  context
                      .read<ReviewBloc>()
                      .add(LoadReviews(productId));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Show more reviews'),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.pop(context); // go back to write review
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class _RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;

  const _RatingSummary({
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < averageRating.round()
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.cyan,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('$totalReviews Ratings',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: List.generate(5, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text('${5 - i}'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (5 - i) / 5,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}


class _FilterRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(text: 'Most Recent', selected: true),
        const SizedBox(width: 12),
        _FilterChip(text: 'With Photos'),
        const SizedBox(width: 12),
        _FilterChip(text: 'Highest Rated'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool selected;

  const _FilterChip({
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor:
        selected ? Colors.cyan.withOpacity(0.1) : null,
        side: BorderSide(
          color: selected ? Colors.cyan : Colors.grey.shade300,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.cyan : Colors.black,
        ),
      ),
    );
  }
}


class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final date = review.createdAt != null
        ? DateFormat('MMM dd, yyyy').format(review.createdAt!)
        : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(
                  review.userName.substring(0, 1).toUpperCase(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(
                      5,
                          (i) => Icon(
                        i < review.rating
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (date.isNotEmpty)
                Text(date, style: const TextStyle(color: Colors.black38)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'VERIFIED PURCHASE',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Was this review helpful?',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined,
                    size: 16),
                label: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('No'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
