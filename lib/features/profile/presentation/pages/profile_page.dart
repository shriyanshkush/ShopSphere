import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/constants/Routes.dart';
import 'package:shopsphere/features/checkout/presentation/pages/checkout_address_page.dart';
import 'package:shopsphere/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:shopsphere/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:shopsphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shopsphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:shopsphere/features/profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(ProfileRepositoryImpl(ProfileRemoteDataSource()))..add(LoadProfile()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async => context.read<ProfileBloc>().add(LoadProfile()),
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF1BDDE2), Color(0xFF0FC6CF)]),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('amazon.in', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                              Row(
                                children: [
                                  _circleIcon(Icons.notifications_none),
                                  const SizedBox(width: 10),
                                  _circleIcon(Icons.search),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Welcome back,', style: TextStyle(color: Colors.white, fontSize: 18)),
                          const Text('Shrish', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: _QuickCard(
                              'Your Orders',
                              Icons.shopping_bag_outlined,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutAddressPage()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(child: _QuickCard('Become Seller', Icons.store_outlined)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Row(
                        children: [
                          Expanded(child: _QuickCard('Wishlist', Icons.favorite_border, onTap: () => Navigator.pushNamed(context, Routes.wishlist))),
                          const SizedBox(width: 12),
                          const Expanded(child: _QuickCard('Logout', Icons.logout)),
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF1BDDE2), Color(0xFF0FC6CF)]),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('amazon.in', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800)),
                          SizedBox(height: 18),
                          Text('Welcome back,', style: TextStyle(color: Colors.white, fontSize: 26)),
                          Text('Shrish', style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(child: _QuickCard('Your Orders', Icons.shopping_bag_outlined)),
                          SizedBox(width: 12),
                          Expanded(child: _QuickCard('Become Seller', Icons.store_outlined)),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(child: _QuickCard('Wishlist', Icons.favorite_border)),
                          SizedBox(width: 12),
                          Expanded(child: _QuickCard('Logout', Icons.logout)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.w700))),
                          const Text('Recent Orders', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                          TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Colors.cyan, fontSize: 22))),
                        ],
                      ),
                    ),
                    if (state.loading)
                      const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()))
                    else ...[
                      const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                    else
                      ...state.orders.map(
                        (e) => _OrderTile(
                          title: e.title,
                          status: e.status,
                          image: e.image,
                          canTrack: e.canTrack,
                          canReview: e.canReview,
                          productId: e.productId,
                          onReview: () {
                            if (e.productId.isNotEmpty) {
                              Navigator.pushNamed(context, Routes.productDetail, arguments: e.productId);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
                        ),
                      ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CheckoutAddressPage()),
                        ),
                        child: const Text('Open Checkout Address Step'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const _QuickCard(this.title, this.icon, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.cyan), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]),
      ),
  const _QuickCard(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.cyan), const SizedBox(height: 16), Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700))]),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final String title;
  final String status;
  final String image;
  final bool canTrack;
  final bool canReview;
  final String productId;
  final VoidCallback? onReview;

  const _OrderTile({required this.title, required this.status, required this.image, required this.canTrack, required this.canReview, required this.productId, this.onReview});

  const _OrderTile({required this.title, required this.status, required this.image, required this.canTrack, required this.canReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: image.isNotEmpty
                ? Image.network(image, height: 70, width: 70, fit: BoxFit.cover)
                : Container(height: 70, width: 70, color: Colors.grey.shade200),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(image, height: 74, width: 74, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text(status, style: TextStyle(fontSize: 15, color: canTrack ? Colors.cyan : const Color(0xFF98A4B8))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (canTrack) _smallBtn('Track', () {}),
                    if (canReview) ...[
                      const SizedBox(width: 8),
                      _smallBtn('Review', onReview ?? () {}),
                    ],
                    const SizedBox(width: 8),
                    _smallBtn('Reorder', () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallBtn(String title, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 34), padding: const EdgeInsets.symmetric(horizontal: 14)),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text(status, style: const TextStyle(fontSize: 16, color: Colors.cyan)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (canTrack) OutlinedButton(onPressed: () {}, child: const Text('Track')),
                    if (canReview) OutlinedButton(onPressed: () {}, child: const Text('Review')),
                    const SizedBox(width: 8),
                    OutlinedButton(onPressed: () {}, child: const Text('Reorder')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
