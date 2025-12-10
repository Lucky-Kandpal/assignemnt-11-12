import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../screens/home_screen.dart';
import '../screens/music_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/mini_player.dart';
import '../widgets/custom_bottom_nav.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static int _previousIndex = 0;
  
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final currentIndex = navigationShell.currentIndex;
          final currentPath = state.uri.path;
          return _HomeShell(
            navigationShell: navigationShell,
            currentIndex: currentIndex,
            currentPath: currentPath,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/music',
                name: 'music',
                builder: (context, state) => const MusicScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wishlist',
                name: 'wishlist',
                builder: (context, state) => const WishlistScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static int getPreviousIndex() => _previousIndex;
  
  static void updatePreviousIndex(int index) {
    if (index != _previousIndex) {
      _previousIndex = index;
    }
  }
}

class _HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final String currentPath;

  const _HomeShell({
    required this.navigationShell,
    required this.currentIndex,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarStyle = currentIndex == 1
        ? const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarStyle,
      child: Scaffold(
        body: Stack(
          children: [
            navigationShell,
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: MiniPlayer(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,
          onChanged: (index) {
            AppRouter.updatePreviousIndex(currentIndex);
            navigationShell.goBranch(
              index,
            );
          },
        ),
      ),
    );
  }
}
