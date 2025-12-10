import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../data/tracks.dart';
import '../providers/favorites_provider.dart';
import '../providers/playback_provider.dart';
import '../router/app_router.dart';
import '../widgets/track_list_item.dart';
import 'wishlist_screen.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      ...{...tracks.map((t) => t.category)}
    ];
    final filtered = _filter == 'All'
        ? tracks
        : tracks.where((t) => t.category == _filter).toList();

    return Container(
      color: const Color(0xFF1F1F1F),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: const Color(0xFF1F1F1F),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    final router = GoRouter.of(context);
                    final previousIndex = AppRouter.getPreviousIndex();
                  
                    final routes = ['/home', '/music', '/wishlist', '/profile'];
                    if (previousIndex >= 0 && previousIndex < routes.length) {
                      context.go(routes[previousIndex]);
                    } else {
                      context.go('/home');
                    }
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'DIVINE MUSIC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _CategoryGrid(
                    categories: categories,
                    selectedCategory: _filter,
                    onCategorySelected: (category) {
                      setState(() => _filter = category);
                    },
                  ),
                  const SizedBox(height: 20),
                  _FavoritesButton(),
                  const SizedBox(height: 20),
                  Consumer<PlaybackProvider>(
                    builder: (context, playback, _) => Column(
                      children: List.generate(
                        filtered.length,
                        (index) {
                          final track = filtered[index];
                          return TrackListItem(
                            track: track,
                            onTap: () => playback.playTrack(track),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const _CategoryGrid({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categoryData = {
      'All': 'All',
      'Aarti': 'AARTI',
      'Pooja': 'POOJA',
      'Bhajans': 'BHAJANS',
    };

    final availableCategories = ['All', ...categories.where((c) => c != 'All')];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableCategories.length,
        itemBuilder: (context, index) {
          final categoryKey = availableCategories[index];
          final displayName = categoryData[categoryKey] ?? categoryKey.toUpperCase();
          final isSelected = selectedCategory == categoryKey;
          
          return Padding(
            padding: EdgeInsets.only(
              right: index < availableCategories.length - 1 ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () => onCategorySelected(categoryKey),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFF613EEA) 
                      : const Color(0xFF613EEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF613EEA),
                    width: isSelected ? 0 : 1.5,
                  ),
                  boxShadow: isSelected 
                      ? []
                      : [
                          BoxShadow(
                            color: const Color(0xFF613EEA).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: isSelected 
                              ? Colors.black54 
                              : const Color(0xFF613EEA).withOpacity(0.8),
                          blurRadius: isSelected ? 4 : 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FavoritesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoritesProvider, PlaybackProvider>(
      builder: (context, favorites, playback, _) {
        final favoriteTracks = tracks
            .where((t) => favorites.isFavorite(t.id))
            .toList(growable: false);
        
            return GestureDetector(
            onTap: () {
                context.go('/wishlist');
            },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF7A4DFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Favorites Songs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

