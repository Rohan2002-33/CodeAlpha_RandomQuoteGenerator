import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final favoriteCount =
        context.select<QuoteProvider, int>((p) => p.favoriteCount);

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.format_quote_outlined),
            selectedIcon: Icon(Icons.format_quote_rounded),
            label: 'Quotes',
          ),
          NavigationDestination(
            icon: Badge.count(
              count: favoriteCount,
              isLabelVisible: favoriteCount > 0,
              child: const Icon(Icons.favorite_border_rounded),
            ),
            selectedIcon: Badge.count(
              count: favoriteCount,
              isLabelVisible: favoriteCount > 0,
              child: const Icon(Icons.favorite_rounded),
            ),
            label: 'Favorites',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}