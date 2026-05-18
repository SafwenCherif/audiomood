import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class NvidiaEmotionDetector {
  Future<String> detectEmotion(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return 'NEUTRAL';
      }

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      final promptContent =
          'Classify the facial expression in this image with exactly one word . <img src="data:image/png;base64,$base64String" />';

      final dio = Dio();
      final response = await dio.post(
        'https://integrate.api.nvidia.com/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization':
                'Bearer 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',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null,
        ),
        data: {
          'model': 'google/gemma-4-31b-it',
          'messages': [
            {'role': 'user', 'content': promptContent},
          ],
          'max_tokens': 256,
          'temperature': 1.00,
          'top_p': 0.95,
          'frequency_penalty': 0.00,
          'presence_penalty': 0.00,
          'stream': false,
          'chat_template_kwargs': {'enable_thinking': true},
        },
      );

      final data = response.data;

      if (response.statusCode == 200) {
        if (data != null &&
            data['choices'] != null &&
            data['choices'].isNotEmpty) {
          final content = data['choices'][0]['message']['content'].toString();
          print('NVIDIA Response: $content');

          // Prefer one of the known labels if present.
          final labelMatch = RegExp(
            r"\b(HAPPY|SAD|ANGRY|NEUTRAL|CALM|CRAZY|FRUSTRATED)\b",
            caseSensitive: false,
          ).firstMatch(content);
          final wordMatch = RegExp(
            r"[A-Za-z]+(?:-[A-Za-z]+)?",
          ).firstMatch(content);
          final cleaned =
              ((labelMatch?.group(0)) ?? wordMatch?.group(0) ?? content)
                  .replaceAll(RegExp(r"[^A-Za-z-]"), '')
                  .trim()
                  .toUpperCase();
          if (cleaned.isNotEmpty) {
            return cleaned;
          }
        }
      } else {
        print('NVIDIA Error Response (${response.statusCode}): $data');
      }
      return 'NEUTRAL';
    } catch (e) {
      print('NVIDIA Error: $e');
      // Fallback if API fails or there is no internet
      return 'NEUTRAL';
    }
  }
}
