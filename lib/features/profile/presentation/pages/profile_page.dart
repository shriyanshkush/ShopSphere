import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopsphere/core/services/api_service.dart';
import 'package:shopsphere/features/profile/data/models/profile_details_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<ProfileDetailsModel> _fetchProfile() async {
    final Dio dio = ApiService().dio;
    final res = await dio.get('/api/profile/details');
    return ProfileDetailsModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: FutureBuilder<ProfileDetailsModel>(
        future: _fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load profile: ${snapshot.error}'),
            );
          }

          final profile = snapshot.data!;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
                decoration: const BoxDecoration(
                  color: Color(0xFF17C3D6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_back_ios, color: Colors.white),
                        Spacer(),
                        Text('Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        Icon(Icons.settings, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
                    const SizedBox(height: 16),
                    Text(profile.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 36)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.16),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(profile.email,
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat('${profile.ordersCount}', 'Orders'),
                  _stat('${profile.wishlistCount}', 'Saved'),
                  _stat(profile.points > 999 ? '${(profile.points / 1000).toStringAsFixed(1)}k' : '${profile.points}', 'Points'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: const [
                    _CardTile(title: 'My Orders', subtitle: 'Track & manage', icon: Icons.inventory_2_outlined),
                    _CardTile(title: 'Wishlist', subtitle: 'Items you loved', icon: Icons.favorite_border),
                    _CardTile(title: 'Coupons', subtitle: 'Active offers', icon: Icons.confirmation_num_outlined),
                    _CardTile(title: 'Help Center', subtitle: '24/7 Support', icon: Icons.support_agent),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _CardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _CardTile({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE2E6)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF17C3D6)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
