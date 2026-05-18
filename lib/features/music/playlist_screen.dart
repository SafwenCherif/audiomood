import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'music_provider.dart';

class PlaylistScreen extends ConsumerWidget {
  final String emotion;

  const PlaylistScreen({super.key, required this.emotion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the FutureProvider we created earlier
    final playlistAsyncValue = ref.watch(playlistProvider(emotion));

    return Scaffold(
      appBar: AppBar(
        title: Text('$emotion Playlist 🎵'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back',
        ),
      ),
      body: playlistAsyncValue.when(
        // 1. Loading State (UI/UX Requirement)
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Fetching vibes from Deezer..."),
            ],
          ),
        ),
        // 2. Error State (Graceful Error Handling Requirement)
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Oops! Couldn't load music.\nCheck your internet connection.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
        // 3. Success State (Data Visualization)
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(child: Text("No tracks found for this mood."));
          }
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];

              // Watch what is currently playing so we can change the icon!
              final playingUrl = ref.watch(currentlyPlayingProvider);
              final isPlayingThisTrack = playingUrl == track.previewUrl;

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
                  // Change icon based on state
                  trailing: Icon(
                    isPlayingThisTrack
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.deepPurple,
                    size: 35,
                  ),
                  // MAGIC HAPPENS HERE
                  onTap: () async {
                    if (track.previewUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "No audio preview available for this track.",
                          ),
                        ),
                      );
                      return;
                    }

                    final player = ref.read(audioPlayerProvider);

                    if (isPlayingThisTrack) {
                      // If it's already playing, pause it
                      await player.pause();
                      ref.read(currentlyPlayingProvider.notifier).state = null;
                    } else {
                      // Play the new track
                      ref.read(currentlyPlayingProvider.notifier).state =
                          track.previewUrl;
                      await player.setUrl(track.previewUrl);
                      player.play();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
