import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../core/constants.dart';

class EmotionApi {
  // Setting up Dio with strict timeouts (Prof's Rubric requirement)
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<String> detectEmotion(Uint8List imageBytes) async {
    // 1. If no API key is provided yet, return a mock response for testing
    if (AppConstants.googleVisionApiKey.isEmpty) {
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay
      return "HAPPY"; // Fake result based on your awesome photo!
    }

    // 2. Real API Call
    try {
      final String base64Image = base64Encode(imageBytes);
      final response = await _dio.post(
        'https://vision.googleapis.com/v1/images:annotate?key=${AppConstants.googleVisionApiKey}',
        data: {
          "requests": [
            {
              "image": {"content": base64Image},
              "features": [
                {"type": "FACE_DETECTION", "maxResults": 1},
              ],
            },
          ],
        },
      );

      // 3. Parse JSON Response
      final faces = response.data['responses'][0]['faceAnnotations'];
      if (faces == null || faces.isEmpty) return 'NEUTRAL';

      final face = faces[0];
      if (face['joyLikelihood'] == 'VERY_LIKELY' ||
          face['joyLikelihood'] == 'LIKELY')
        return 'HAPPY';
      if (face['sorrowLikelihood'] == 'VERY_LIKELY' ||
          face['sorrowLikelihood'] == 'LIKELY')
        return 'SAD';
      if (face['angerLikelihood'] == 'VERY_LIKELY' ||
          face['angerLikelihood'] == 'LIKELY')
        return 'ANGRY';

      return 'NEUTRAL';
    } on DioException catch (e) {
      // 4. Handle Timeouts & Errors gracefully without crashing
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Connection Timeout: Please check your internet.");
      }
      throw Exception("API Error: ${e.message}");
    }
  }
}
