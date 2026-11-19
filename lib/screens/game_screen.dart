import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_provider.dart';
import '../providers/giveaway_provider.dart';
import '../widgets/game_card.dart';
import 'detail_screen.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final giveawaysAsync = ref.watch(giveawayProvider);
    final theme = Theme.of(context);
    final favoriteIds = ref.watch(favoriteProvider);
    final favoriteController = ref.read(favoriteProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gaming Giveaways',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(giveawayProvider);
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: giveawaysAsync.when(
        // Loading
        loading: () => const Center(child: CircularProgressIndicator()),

        // Error
        error: (error, stackTrace) {
          return _buildError(context, ref, error.toString());
        },

        // Data
        data: (giveaways) {
          if (giveaways.isEmpty) {
            return _buildEmpty(context, ref);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(giveawayProvider.future);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final crossAxisCount = width >= 900
                    ? 4
                    : width >= 600
                    ? 3
                    : 2;

                return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: giveaways.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.73,
                  ),
                  itemBuilder: (context, index) {
                    final giveaway = giveaways[index];

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
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load giveaways',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(giveawayProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videogame_asset_off_outlined,
            size: 56,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: 12),
          Text('No giveaways available', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ref.invalidate(giveawayProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
