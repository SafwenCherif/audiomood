import 'dart:io';
import 'package:flutter/material.dart';
import '../music/playlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'local_emotion_detector.dart'; // Import our new AI file!
import '../music/music_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tflite_emotion_detector.dart';
import 'ml_kit_emotion_detection.dart';
import '../auth/auth_provider.dart';
import '../history/history_provider.dart';
import '../history/history_screen.dart';

enum EmotionDetectionMethod { nvidia, tflite, mlkit }

final emotionMethodProvider = StateProvider<EmotionDetectionMethod>(
  (ref) => EmotionDetectionMethod.nvidia,
);

// Riverpod provider to hold the file path (Best for Android)
final selectedImagePathProvider = StateProvider<String?>((ref) => null);
final isLoadingProvider = StateProvider<bool>((ref) => false);

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  @override
  void initState() {
    super.initState();
    _loadDetectionMethod();
  }

  Future<void> _loadDetectionMethod() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('emotion_method');
    if (value == null) return;

    final method = value == 'tflite'
        ? EmotionDetectionMethod.tflite
        : value == 'mlkit'
        ? EmotionDetectionMethod.mlkit
        : EmotionDetectionMethod.nvidia;
    ref.read(emotionMethodProvider.notifier).state = method;
  }

  Future<void> _saveDetectionMethod(EmotionDetectionMethod method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'emotion_method',
      method == EmotionDetectionMethod.tflite
          ? 'tflite'
          : method == EmotionDetectionMethod.mlkit
          ? 'mlkit'
          : 'nvidia',
    );
  }

  Future<void> _pickImage(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    // This will open the real Android camera!
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      ref.read(selectedImagePathProvider.notifier).state = image.path;
    }
  }

  Future<void> _analyzeEmotion(BuildContext context, WidgetRef ref) async {
    final imagePath = ref.read(selectedImagePathProvider);
    if (imagePath == null) return;

    ref.read(isLoadingProvider.notifier).state = true;
    final method = ref.read(emotionMethodProvider);
    final user = FirebaseAuth.instance.currentUser;
    final historyRepo = ref.read(moodHistoryRepositoryProvider);

    try {
      if (user == null) {
        throw Exception('Please sign in to save your mood history.');
      }

      final imageUrl = await historyRepo.uploadImage(imagePath);

      final emotion = method == EmotionDetectionMethod.tflite
          ? await TfliteEmotionDetector().detectEmotion(imagePath)
          : method == EmotionDetectionMethod.mlkit
          ? await MlKitEmotionDetector().detectEmotion(imagePath)
          : await NvidiaEmotionDetector().detectEmotion(imagePath);

      final tracks = await ref.read(playlistProvider(emotion).future);
      final previewUrl = tracks.isNotEmpty ? tracks.first.previewUrl : '';

      final history = historyRepo.buildHistory(
        userId: user.uid,
        imageUrl: imageUrl,
        mood: emotion,
        previewUrl: previewUrl,
      );

      await historyRepo.saveHistory(history);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Emotion detected: $emotion! 🎵'),
            backgroundColor: Colors.green,
          ),
        );
        // NEXT STEP: Navigate to the Deezer Playlist Screen!
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(emotion: emotion),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = ref.watch(selectedImagePathProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final lastEmotionAsync = ref.watch(lastEmotionProvider);
    final selectedMethod = ref.watch(emotionMethodProvider);
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'AudioMood User';
    final email = user?.email ?? '';
    final photoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Emotion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(displayName),
              accountEmail: email.isEmpty ? null : Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: photoUrl == null
                    ? null
                    : NetworkImage(photoUrl),
                child: photoUrl == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              decoration: const BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Show history'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: imagePath != null
                  // Use Image.file for Android
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.face, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No face captured yet"),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: Column(
                children: [
                  const Text(
                    'Detection method',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('NVIDIA Build'),
                        selected:
                            selectedMethod == EmotionDetectionMethod.nvidia,
                        onSelected: isLoading
                            ? null
                            : (selected) {
                                if (!selected) return;
                                ref.read(emotionMethodProvider.notifier).state =
                                    EmotionDetectionMethod.nvidia;
                                _saveDetectionMethod(
                                  EmotionDetectionMethod.nvidia,
                                );
                              },
                      ),
                      ChoiceChip(
                        label: const Text('Local TFLite'),
                        selected:
                            selectedMethod == EmotionDetectionMethod.tflite,
                        onSelected: isLoading
                            ? null
                            : (selected) {
                                if (!selected) return;
                                ref.read(emotionMethodProvider.notifier).state =
                                    EmotionDetectionMethod.tflite;
                                _saveDetectionMethod(
                                  EmotionDetectionMethod.tflite,
                                );
                              },
                      ),
                      ChoiceChip(
                        label: const Text('ML Kit'),
                        selected:
                            selectedMethod == EmotionDetectionMethod.mlkit,
                        onSelected: isLoading
                            ? null
                            : (selected) {
                                if (!selected) return;
                                ref.read(emotionMethodProvider.notifier).state =
                                    EmotionDetectionMethod.mlkit;
                                _saveDetectionMethod(
                                  EmotionDetectionMethod.mlkit,
                                );
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            lastEmotionAsync.when(
              data: (lastEmotion) => lastEmotion == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Text(
                          'Last mood: $lastEmotion',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PlaylistScreen(emotion: lastEmotion),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.history),
                          label: const Text('Use last mood'),
                        ),
                      ],
                    ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: isLoading ? null : () => _pickImage(ref),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
                const SizedBox(width: 20),
                if (imagePath != null)
                  ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _analyzeEmotion(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(isLoading ? 'Analyzing...' : 'Find Playlist'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
