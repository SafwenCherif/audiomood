import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/track_model.dart';

// --- ALL PROVIDERS MUST BE AT THE TOP LEVEL ---

// 1. Provider to hold the currently detected emotion
final currentEmotionProvider = StateProvider<String>((ref) => 'HAPPY');

// 2. Provider to hold the AudioPlayer instance safely (MOVED OUTSIDE!)
final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  // This ensures the music stops and memory is freed when you close the app
  ref.onDispose(() => player.dispose());
  return player;
});

// 3. Provider to track which song is currently playing (MOVED OUTSIDE!)
final currentlyPlayingProvider = StateProvider<String?>((ref) => null);

// 3b. Provider to read the last detected emotion (Persistence requirement)
final lastEmotionProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_emotion');
});

// 4. Riverpod FutureProvider to fetch music AND save the emotion to LocalStorage
final playlistProvider = FutureProvider.family<List<Track>, String>((
  ref,
  emotion,
) async {
  // Data Persistence: Save the emotion offline so we remember it next time
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_emotion', emotion);

  // Consume Deezer API based on the emotion
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10), // Handling timeouts!
    ),
  );

  final response = await dio.get(
    'https://api.deezer.com/search?q=${emotion.toLowerCase()} music',
  );

  // Parse the JSON list into our Dart objects
  final List data = response.data['data'];
  return data.map((json) => Track.fromJson(json)).toList();
});
