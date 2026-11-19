import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

class FavoriteController extends Notifier<Set<int>> {
  static const String _favoriteKey = 'favoriteGiveawayIds';

  @override
  Set<int> build() {
    return {};
  }

  Future<void> loadFavorites() async {
    try {
      final savedIds = await _storage.read(key: _favoriteKey);

      if (savedIds == null || savedIds.isEmpty) {
        state = {};
        return;
      }

      state = savedIds
          .split(',')
          .map((id) => int.tryParse(id))
          .whereType<int>()
          .toSet();
    } catch (e) {
      state = {};
    }
  }

  Future<void> toggleFavorite(int id) async {
    final updatedFavorites = Set<int>.from(state);

    if (updatedFavorites.contains(id)) {
      updatedFavorites.remove(id);
    } else {
      updatedFavorites.add(id);
    }

    state = updatedFavorites;

    await _saveFavorites();
  }

  bool isFavorite(int id) {
    return state.contains(id);
  }

  Future<void> _saveFavorites() async {
    final ids = state.toList()..sort();

    await _storage.write(key: _favoriteKey, value: ids.join(','));
  }
}

final favoriteProvider = NotifierProvider<FavoriteController, Set<int>>(
  FavoriteController.new,
);
