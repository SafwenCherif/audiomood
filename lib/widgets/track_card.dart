import 'package:flutter/material.dart';
import '../models/track_model.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({
    super.key,
    required this.track,
    required this.isPlayingThisTrack,
    required this.onTap,
  });

  final Track track;
  final bool isPlayingThisTrack;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 3,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            track.coverUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.music_note, size: 50),
          ),
        ),
        title: Text(
          track.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(track.artist),
        trailing: Icon(
          isPlayingThisTrack
              ? Icons.pause_circle_filled
              : Icons.play_circle_fill,
          color: Colors.deepPurple,
          size: 35,
        ),
        onTap: onTap,
      ),
    );
  }
}
