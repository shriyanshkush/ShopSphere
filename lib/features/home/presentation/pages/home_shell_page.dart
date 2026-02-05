import 'package:flutter/material.dart';
import 'package:shopsphere/features/home/presentation/pages/home_page.dart';
import 'package:shopsphere/features/home/presentation/pages/search_page.dart';
import 'package:shopsphere/features/profile/presentation/pages/profile_page.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(showBottomNav: false),
      const SearchPage(),
      const ProfilePage(),
      const _MorePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: const Color(0xFF8392A7),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}

class _MorePage extends StatelessWidget {
  const _MorePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('More options coming soon'),
      ),
    );
  }
}
