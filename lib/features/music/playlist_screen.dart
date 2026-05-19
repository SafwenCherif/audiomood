import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import 'music_provider.dart';
import '../../widgets/track_card.dart';

class PlaylistScreen extends StatelessWidget {
  final String emotion;

  const PlaylistScreen({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer(
      builder: (context, ref, _) {
        final playlistAsyncValue = ref.watch(playlistProvider(emotion));

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.playlistTitle(emotion)),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              tooltip: l10n.goBack,
            ),
          ),
          body: playlistAsyncValue.when(
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.fetchingFromDeezer),
                ],
              ),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.playlistLoadError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
            data: (tracks) {
              if (tracks.isEmpty) {
                return Center(child: Text(l10n.noTracksForMood));
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
                          SnackBar(content: Text(l10n.noPreviewAvailable)),
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
