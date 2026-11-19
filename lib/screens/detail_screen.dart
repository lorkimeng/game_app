import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/giveaway_model.dart';

class DetailScreen extends StatelessWidget {
  final GiveawayModel giveaway;

  const DetailScreen({super.key, required this.giveaway});

  Future<void> _openGiveaway(BuildContext context) async {
    final url = giveaway.openGiveawayUrl.isNotEmpty
        ? giveaway.openGiveawayUrl.trim()
        : giveaway.gamerpowerUrl.trim();

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giveaway link is unavailable.')),
      );
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid giveaway link.')));
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.link),
              SizedBox(width: 8),
              Text('Giveaway Link'),
            ],
          ),
          content: SelectableText(
            url,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Giveaway link copied!')),
                );
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copy Link'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Giveaway Details')),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                giveaway.image.isNotEmpty ? giveaway.image : giveaway.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Image Error: $error');

                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Worth and type
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildBadge(
                        context,
                        giveaway.worth.isEmpty ? 'Free' : giveaway.worth,
                        colorScheme.primary,
                      ),
                      _buildBadge(
                        context,
                        giveaway.type,
                        colorScheme.secondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    giveaway.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Platforms
                  _buildSectionTitle(context, 'Platforms'),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _platformList(giveaway.platforms)
                        .map(
                          (platform) => Chip(
                            avatar: const Icon(
                              Icons.devices_outlined,
                              size: 16,
                            ),
                            label: Text(platform),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  _buildSectionTitle(context, 'Description'),

                  const SizedBox(height: 8),

                  Text(
                    _displayText(giveaway.description),
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),

                  const SizedBox(height: 20),

                  // Instructions
                  _buildSectionTitle(context, 'Instructions'),

                  const SizedBox(height: 8),

                  Text(
                    _displayText(giveaway.instructions),
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),

                  const SizedBox(height: 20),

                  // Giveaway Information
                  _buildSectionTitle(context, 'Giveaway Information'),

                  const SizedBox(height: 12),

                  _buildInfoRow(
                    context,
                    Icons.calendar_today_outlined,
                    'End Date',
                    giveaway.endDate,
                  ),

                  const SizedBox(height: 8),

                  _buildInfoRow(
                    context,
                    Icons.access_time,
                    'Published Date',
                    giveaway.publishedDate,
                  ),

                  const SizedBox(height: 28),

                  // Get Giveaway button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openGiveaway(context),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Get Giveaway'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Giveaway information provided by GamerPower',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label: ${_displayText(value)}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  String _displayText(String value) {
    return value.trim().isEmpty ? 'Not available' : value.trim();
  }

  List<String> _platformList(String platforms) {
    return platforms
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
