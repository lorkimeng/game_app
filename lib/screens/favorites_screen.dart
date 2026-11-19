import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_provider.dart';
import '../providers/giveaway_provider.dart';
import '../widgets/game_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteProvider);
    final giveawaysAsync = ref.watch(giveawayProvider);
    final theme = Theme.of(context);
    final favoriteController = ref.read(favoriteProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: giveawaysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Unable to load favorites: $error')),
        data: (giveaways) {
          final favoriteGames = giveaways
              .where((game) => favoriteIds.contains(game.id))
              .toList();

          if (favoriteGames.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  Text('No favorites yet', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Add games to your favorites to see them here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoriteGames.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final giveaway = favoriteGames[index];

              return GameCard(
                giveaway: giveaway,
                isFavorite: favoriteIds.contains(giveaway.id),
                onFavoriteTap: () {
                  favoriteController.toggleFavorite(giveaway.id);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(giveaway: giveaway),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
