import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'music_provider.dart';
import '../../widgets/track_card.dart';

class PlaylistScreen extends StatelessWidget {
  final String emotion;

  const PlaylistScreen({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
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
            data: (tracks) {
              if (tracks.isEmpty) {
                return const Center(
                  child: Text("No tracks found for this mood."),
                );
              }
              return ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];

                  final playingUrl = ref.watch(currentlyPlayingProvider);
                  final isPlayingThisTrack = playingUrl == track.previewUrl;

                  return TrackCard(
                    track: track,
                    isPlayingThisTrack: isPlayingThisTrack,
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
                        await player.pause();
                        ref.read(currentlyPlayingProvider.notifier).state =
                            null;
                      } else {
                        ref.read(currentlyPlayingProvider.notifier).state =
                            track.previewUrl;
                        await player.setUrl(track.previewUrl);
                        player.play();
                      }
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
