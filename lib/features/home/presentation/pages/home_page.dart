import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/common/constants/GlobalVariable.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/home/presentation/pages/bottom_nav.dart';
import 'package:shopsphere/features/home/presentation/pages/category_row.dart';
import 'package:shopsphere/features/home/presentation/pages/home_app_bar.dart';
import 'package:shopsphere/features/home/presentation/pages/product_grid.dart';
import 'package:shopsphere/features/home/presentation/pages/widgets/CarouselWidget.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';



class HomePage extends StatelessWidget {
  final bool showBottomNav;

  const HomePage({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: showBottomNav ? const BottomNav() : null,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            /// 🔑 Load home once
            if (!state.loading && state.products.isEmpty) {
              context.read<HomeBloc>().add(LoadHome());
            }

            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // return SingleChildScrollView(
            //   physics: const BouncingScrollPhysics(),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Padding(
            //         padding: EdgeInsets.all(16),
            //         child: HomeAppBar(),
            //       ),
            //
            //       /// 🔍 SEARCH
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: Row(
            //           children: [
            //             /// 🔍 SEARCH FIELD
            //             Expanded(
            //               child: Container(
            //                 height: 52,
            //                 padding: const EdgeInsets.symmetric(horizontal: 16),
            //                 decoration: BoxDecoration(
            //                   color: Colors.white,
            //                   borderRadius: BorderRadius.circular(32),
            //                   border: Border.all(
            //                     color: Colors.cyan.withOpacity(0.35),
            //                     width: 1.5,
            //                   ),
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     const Icon(
            //                       Icons.search,
            //                       color: Colors.cyan,
            //                       size: 22,
            //                     ),
            //                     const SizedBox(width: 8),
            //                     Expanded(
            //                       child: TextField(
            //                         decoration: const InputDecoration(
            //                           hintText: 'Search premium tech...',
            //                           hintStyle: TextStyle(
            //                             color: Colors.grey,
            //                             fontSize: 14,
            //                           ),
            //                           border: InputBorder.none,
            //                           isDense: true,
            //                         ),
            //                         onChanged: (q) => context
            //                             .read<HomeBloc>()
            //                             .add(SearchSubmitted(q)),
            //                         onSubmitted: (q) => context
            //                             .read<HomeBloc>()
            //                             .add(SearchSubmitted(q)),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //
            //             const SizedBox(width: 12),
            //
            //             /// 🎤 MIC BUTTON
            //             Container(
            //               height: 52,
            //               width: 52,
            //               decoration: const BoxDecoration(
            //                 color: Colors.cyan,
            //                 shape: BoxShape.circle,
            //               ),
            //               child: const Icon(
            //                 Icons.mic,
            //                 color: Colors.white,
            //                 size: 22,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //
            //
            //
            //       const SizedBox(height: 16),
            //
            //       /// 🎯 BANNER / CAROUSEL
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(24),
            //           child: const CarouselWidget(),
            //         ),
            //       ),
            //
            //
            //       const SizedBox(height: 16),
            //
            //       /// 🗂 CATEGORIES (optional but recommended)
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: CategoryRow(
            //           categories:GlobalVariable.categories
            //         ),
            //       ),
            //
            //       const SizedBox(height: 16),
            //
            //
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: Text("Top Products",style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),),
            //       ),
            //       const SizedBox(height: 16),
            //       /// 🛍 PRODUCTS
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: ProductGrid(
            //           onProductTap: (id) {
            //             Navigator.pushNamed(
            //               context,
            //               Routes.productDetail,
            //               arguments: id,
            //             );
            //           },
            //           products: state.products,
            //           wishlist: state.wishlist,
            //           onWishlistTap: (id) => context
            //               .read<HomeBloc>()
            //               .add(ToggleWishlist(id)),
            //           onAddToCart: () =>
            //               context.read<HomeBloc>().add(AddToCart()),
            //         ),
            //       ),
            //     ],
            //   ),
            // );

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                /// 👤 TOP PROFILE BAR
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: HomeAppBar(),
                  ),
                ),

                /// 🔍 STICKY SEARCH BAR
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  toolbarHeight: 84,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: _StickySearchBar(),
                  ),
                ),

                /// 🎯 CAROUSEL
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: const CarouselWidget(),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                /// 🗂 CATEGORIES
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategoryRow(
                      categories: _buildCategoryItems(state),
                      onCategoryTap: (name) {
                        Navigator.pushNamed(context, Routes.categoryProducts, arguments: name);
                      },
                      onSeeAll: () {
                        final first = state.categories.isEmpty ? 'Mobiles' : state.categories.first;
                        Navigator.pushNamed(context, Routes.categoryProducts, arguments: first);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                /// 🏷 TOP PRODUCTS TITLE
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Top Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                /// 🛍 PRODUCTS
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: ProductGrid(
                      products: state.products,
                      wishlist: state.wishlist,
                      onWishlistTap: (id) => context
                          .read<HomeBloc>()
                          .add(ToggleWishlist(id)),
                      onAddToCart: (id) =>
                          context.read<HomeBloc>().add(AddToCart(id)),
                      onProductTap: (id) {
                        Navigator.pushNamed(
                          context,
                          Routes.productDetail,
                          arguments: id,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );

          },
        ),
      ),
    );
  }
}

class _StickySearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.cyan.withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.cyan),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search premium tech...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (q) => context.read<HomeBloc>().add(SearchQueryChanged(q)),
                    onSubmitted: (q) => context.read<HomeBloc>().add(SearchSubmitted(q)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          width: 52,
          decoration: const BoxDecoration(
            color: Colors.cyan,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      ],
    );
  }
}


List<Map<String, String>> _buildCategoryItems(HomeState state) {
  if (state.categories.isEmpty) return GlobalVariable.categories;

  String iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('mobile')) return 'assets/icons/cell-phone.png';
    if (n.contains('laptop')) return 'assets/icons/laptop.png';
    if (n.contains('audio')) return 'assets/icons/headphone.png';
    if (n.contains('watch')) return 'assets/icons/wristwatch.png';
    if (n.contains('camera')) return 'assets/icons/photo_camera.png';
    return 'assets/icons/laptop.png';
  }

  return state.categories.map((c) => {'name': c, 'icon': iconFor(c)}).toList();
}
