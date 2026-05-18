import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MlKitEmotionDetector {
  Future<String> detectEmotion(String imagePath) async {
    final options = FaceDetectorOptions(enableClassification: true);
    final faceDetector = FaceDetector(options: options);

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        return 'UNKNOWN'; // Literally no face in the photo
      }

      final face = faces.first;

      if (face.smilingProbability != null) {
        final smileProb = face.smilingProbability!;

        // Let's use smarter math thresholds!
        if (smileProb > 0.55) {
          return 'HAPPY'; // Big smile
        } else if (smileProb < 0.15) {
          return 'SAD'; // Frowning or very serious
        } else {
          return 'NEUTRAL'; // Just chilling (between 0.15 and 0.55)
        }
      }
      return 'NEUTRAL'; // Fallback
    } catch (e) {
      throw Exception('AI Detection Error: $e');
    } finally {
      faceDetector.close();
    }
  }
}
