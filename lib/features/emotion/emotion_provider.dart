import 'package:flutter_riverpod/flutter_riverpod.dart';

enum EmotionDetectionMethod { groq, tflite, mlkit }

final emotionMethodProvider = StateProvider<EmotionDetectionMethod>(
  (ref) => EmotionDetectionMethod.groq,
);

final selectedImagePathProvider = StateProvider<String?>((ref) => null);

final isLoadingProvider = StateProvider<bool>((ref) => false);
