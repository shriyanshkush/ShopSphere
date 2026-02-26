import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/review/ReviewBloc.dart';
import '../blocs/review/ReviewEvent.dart';
import '../blocs/review/ReviewState.dart';

class WriteReviewPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String productSubtitle;
  final String productImage;

  const WriteReviewPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.productSubtitle,
    required this.productImage,
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int rating = 0;
  final commentCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  bool anonymous = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state.success) {
          Navigator.pop(context);
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Write a Review'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🧾 PRODUCT CARD
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.productImage,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(widget.productSubtitle,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// ⭐ RATING
                const Text('Overall Rating',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (i) {
                    return IconButton(
                      icon: Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        color: Colors.cyan,
                        size: 32,
                      ),
                      onPressed: () => setState(() => rating = i + 1),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.photo_camera, color: Colors.cyan),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add a Photo or Video', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Help others see the product details', style: TextStyle(color: Colors.black54)),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text('Write your review',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: commentCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:
                    'What did you like or dislike? How are you using the product?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🧠 HEADLINE
                const Text('Headline',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    hintText: 'Summarize your review in a few words',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 👤 ANONYMOUS
                SwitchListTile(
                  title: const Text('Post Anonymously'),
                  subtitle:
                  const Text("Your profile name won't be visible"),
                  value: anonymous,
                  onChanged: (v) => setState(() => anonymous = v),
                ),

                const SizedBox(height: 24),

                /// 🚀 SUBMIT
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: rating == 0 || state.loading
                        ? null
                        : () {
                      context.read<ReviewBloc>().add(
                        SubmitReview(
                          productId: widget.productId,
                          rating: rating,
                          comment: commentCtrl.text,
                        ),
                      );
                    },
                    child: state.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Review'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
