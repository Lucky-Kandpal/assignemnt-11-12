import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _prefsKey = 'favorite_tracks';
  Set<String> _favoriteIds = {};
  bool _initialized = false;

  Set<String> get favorites => _favoriteIds;
  bool get isReady => _initialized;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList(_prefsKey)?.toSet() ?? {};
    _initialized = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(String trackId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteIds.contains(trackId)) {
      _favoriteIds.remove(trackId);
    } else {
      _favoriteIds.add(trackId);
    }
    await prefs.setStringList(_prefsKey, _favoriteIds.toList());
    notifyListeners();
  }

  bool isFavorite(String trackId) => _favoriteIds.contains(trackId);
}

