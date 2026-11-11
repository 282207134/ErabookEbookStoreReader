import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_state.dart';
import 'main_tabs.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  static const tabs = [
    HomeTab(),
    DiscoverTab(),
    LibraryTab(),
    LibraryTab(purchased: true),
    AccountTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final dark = AppState.instance.dark;
        return Scaffold(
          // Recreate tabs when brightness flips so cached text colors refresh.
          body: KeyedSubtree(
            key: ValueKey(dark),
            child: IndexedStack(index: index, children: tabs),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: dark ? C.dark2 : Colors.white,
              border: Border(top: BorderSide(color: dark ? C.dark4 : C.g200)),
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: (i) => setState(() => index = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: C.primary,
              unselectedItemColor: C.g500,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  activeIcon: Icon(Icons.bookmark),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  activeIcon: Icon(Icons.shopping_bag),
                  label: 'Purchased',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
