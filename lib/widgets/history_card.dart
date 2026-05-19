import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/mood_history_model.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.history, required this.onTap});

  final MoodHistoryModel history;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date = history.createdAt.toDate();
    final formatted =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            history.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(
          history.mood.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.savedOn(formatted)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
