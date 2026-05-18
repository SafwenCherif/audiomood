import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  CloudinaryService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<String> uploadImage(String filePath) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

    if (cloudName.isEmpty || uploadPreset.isEmpty) {
      throw Exception('Cloudinary configuration missing');
    }

    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'upload_preset': uploadPreset,
    });

    final response = await _dio.post(url, data: formData);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return data['secure_url'] as String? ?? '';
    }

    throw Exception('Cloudinary upload failed');
  }
}
