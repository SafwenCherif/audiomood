import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/network/network_service.dart';

class GroqEmotionDetector {
  Future<String> detectEmotion(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return 'NEUTRAL';
      }

      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception(
          'Groq API key missing. Add GROQ_API_KEY to your .env file.',
        );
      }

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      final extension = imagePath.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final dio = Dio(
        BaseOptions(
          connectTimeout: NetworkService.defaultTimeout,
          sendTimeout: NetworkService.defaultTimeout,
          receiveTimeout: NetworkService.defaultTimeout,
        ),
      );

      final response = await dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null,
        ),
        data: {
          // UPDATE: Replaced the decommissioned model with the current Groq vision model
          'model': 'meta-llama/llama-4-scout-17b-16e-instruct',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text':
                      'Return ONLY JSON: {"label":"<LABEL>"}. Label must be exactly one of: HAPPY, SAD, ANGRY, NEUTRAL, CALM, CRAZY, FRUSTRATED. No extra text.',
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:$mimeType;base64,$base64String'},
                },
              ],
            },
          ],
          // UPDATE: Removed duplicate max_tokens key
          'max_tokens': 32,
          'temperature': 0.1,
          'response_format': {'type': 'json_object'},
        },
      );

      final data = response.data;

      if (response.statusCode != 200) {
        final errorMessage = data is Map && data['error'] != null
            ? data['error']['message']?.toString()
            : 'Groq request failed.';
        throw NetworkException(
          NetworkFailureType.server,
          'Groq error (${response.statusCode}): $errorMessage',
        );
      }

      if (data == null || data['choices'] == null || data['choices'].isEmpty) {
        throw NetworkException(
          NetworkFailureType.server,
          'Groq response was empty. Please try again.',
        );
      }

      final content = data['choices'][0]['message']['content'].toString();
      final parsedLabel = _extractLabel(content);
      if (parsedLabel != null) {
        return parsedLabel;
      }

      throw NetworkException(
        NetworkFailureType.server,
        'Groq returned an unexpected label: $content',
      );
    } catch (e) {
      throw NetworkService.from(e);
    }
  }

  String? _extractLabel(String content) {
    const allowed = {
      'HAPPY',
      'SAD',
      'ANGRY',
      'NEUTRAL',
      'CALM',
      'CRAZY',
      'FRUSTRATED',
    };

    const synonyms = {
      'CONTENT': 'CALM',
      'RELAXED': 'CALM',
      'UPSET': 'FRUSTRATED',
      'FRUSTRATION': 'FRUSTRATED',
      'MAD': 'ANGRY',
      'FURIOUS': 'ANGRY',
      'JOY': 'HAPPY',
      'SMILE': 'HAPPY',
      'SMILING': 'HAPPY',
      'SADNESS': 'SAD',
    };

    try {
      final decoded = jsonDecode(content);
      if (decoded is Map && decoded['label'] != null) {
        final raw = decoded['label'].toString().toUpperCase().trim();
        if (allowed.contains(raw)) return raw;
        if (synonyms.containsKey(raw)) return synonyms[raw];
      }
    } catch (_) {
      // Ignore JSON parse errors and try regex fallback.
    }

    final labelMatch = RegExp(
      r"\b(HAPPY|SAD|ANGRY|NEUTRAL|CALM|CRAZY|FRUSTRATED)\b",
      caseSensitive: false,
    ).firstMatch(content);

    final cleaned = (labelMatch?.group(0) ?? '')
        .replaceAll(RegExp(r"[^A-Za-z-]"), '')
        .trim()
        .toUpperCase();

    if (allowed.contains(cleaned)) return cleaned;
    if (synonyms.containsKey(cleaned)) return synonyms[cleaned];
    return null;
  }
}
