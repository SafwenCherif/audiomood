import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class TfliteEmotionDetector {
  static const String _modelPath = 'lib/assets/model_unquant.tflite';
  static const String _labelsPath = 'lib/assets/labels.txt';

  static Interpreter? _interpreter;
  static List<String>? _labels;

  Future<String> detectEmotion(String imagePath) async {
    try {
      await _ensureLoaded();
      if (_interpreter == null || _labels == null || _labels!.isEmpty) {
        return 'NEUTRAL';
      }

      final file = File(imagePath);
      if (!await file.exists()) {
        return 'NEUTRAL';
      }

      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        return 'NEUTRAL';
      }

      final faceImage =
          await _cropFaceIfPossible(decoded, imagePath) ?? decoded;

      final inputTensor = _interpreter!.getInputTensor(0);
      final inputShape = inputTensor.shape;
      final inputType = inputTensor.type;
      print('TFLite labels loaded: ${_labels?.length}');
      print('TFLite input shape: $inputShape type: $inputType');

      final height = inputShape[1];
      final width = inputShape[2];
      final channels = inputShape.length > 3 ? inputShape[3] : 1;

      final resized = img.copyResize(faceImage, width: width, height: height);
      final input = _buildInput(resized, height, width, channels, inputType);

      final outputTensor = _interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      final outputType = outputTensor.type;
      print('TFLite output shape: $outputShape type: $outputType');
      final labelIndex = outputType == TensorType.uint8
          ? _runUint8Output(input, outputShape)
          : _runFloatOutput(input, outputShape);

      if (labelIndex < 0 || labelIndex >= _labels!.length) {
        return 'NEUTRAL';
      }

      return _cleanLabel(_labels![labelIndex]);
    } catch (e) {
      print('TFLite error: $e');
      return 'NEUTRAL';
    }
  }

  Future<void> _ensureLoaded() async {
    if (_interpreter != null && _labels != null) return;

    _interpreter ??= await Interpreter.fromAsset(_modelPath);

    final labelData = await rootBundle.loadString(_labelsPath);
    _labels = labelData
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  Future<img.Image?> _cropFaceIfPossible(
    img.Image source,
    String imagePath,
  ) async {
    final options = FaceDetectorOptions(
      enableClassification: false,
      enableLandmarks: false,
      enableContours: false,
    );
    final detector = FaceDetector(options: options);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await detector.processImage(inputImage);
      if (faces.isEmpty) return null;

      final face = faces.first;
      final rect = face.boundingBox;

      // Add padding around face for better context
      const paddingRatio = 0.25;
      final padX = rect.width * paddingRatio;
      final padY = rect.height * paddingRatio;

      final left = (rect.left - padX).clamp(0, source.width - 1).toInt();
      final top = (rect.top - padY).clamp(0, source.height - 1).toInt();
      final right = (rect.right + padX).clamp(0, source.width).toInt();
      final bottom = (rect.bottom + padY).clamp(0, source.height).toInt();

      final cropWidth = (right - left).clamp(1, source.width);
      final cropHeight = (bottom - top).clamp(1, source.height);

      return img.copyCrop(
        source,
        x: left,
        y: top,
        width: cropWidth,
        height: cropHeight,
      );
    } catch (e) {
      return null;
    } finally {
      detector.close();
    }
  }

  int _runFloatOutput(
    List<List<List<List<double>>>> input,
    List<int> outputShape,
  ) {
    final output = List.generate(
      outputShape[0],
      (_) => List.filled(outputShape[1], 0.0),
    );
    _interpreter!.run(input, output);
    final scores = output.first;
    _logTopScores(scores, _labels);
    return _argMaxDouble(scores);
  }

  int _runUint8Output(
    List<List<List<List<double>>>> input,
    List<int> outputShape,
  ) {
    final output = List.generate(
      outputShape[0],
      (_) => List.filled(outputShape[1], 0),
    );
    _interpreter!.run(input, output);
    final scores = output.first.map((v) => v.toDouble()).toList();
    _logTopScores(scores, _labels);
    return _argMaxInt(output.first);
  }

  List<List<List<List<double>>>> _buildInput(
    img.Image image,
    int height,
    int width,
    int channels,
    TensorType inputType,
  ) {
    final input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(width, (x) => List.filled(channels, 0.0)),
      ),
    );

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        if (channels == 1) {
          final value = (r + g + b) / 3.0;
          input[0][y][x][0] = _normalize(value, inputType);
        } else {
          input[0][y][x][0] = _normalize(r, inputType);
          input[0][y][x][1] = _normalize(g, inputType);
          input[0][y][x][2] = _normalize(b, inputType);
        }
      }
    }

    return input;
  }

  double _normalize(double value, TensorType inputType) {
    if (inputType == TensorType.uint8) {
      return value;
    }
    // Teachable Machine float models typically expect [-1, 1]
    return (value / 127.5) - 1.0;
  }

  int _argMaxDouble(List<double> scores) {
    var bestIndex = 0;
    var bestScore = scores[0];
    for (var i = 1; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  int _argMaxInt(List<int> scores) {
    var bestIndex = 0;
    var bestScore = scores[0];
    for (var i = 1; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  String _cleanLabel(String raw) {
    final cleaned = raw.replaceFirst(RegExp(r'^\d+\s*'), '').trim();
    return cleaned.isEmpty ? 'NEUTRAL' : cleaned.toUpperCase();
  }

  void _logTopScores(List<double> scores, List<String>? labels) {
    if (scores.isEmpty || labels == null || labels.isEmpty) return;
    final pairs = <MapEntry<String, double>>[];
    for (var i = 0; i < scores.length && i < labels.length; i++) {
      pairs.add(MapEntry(_cleanLabel(labels[i]), scores[i]));
    }
    pairs.sort((a, b) => b.value.compareTo(a.value));
    final top = pairs.take(3).map((e) => '${e.key}:${e.value}').join(', ');
    print('TFLite top scores: $top');
  }
}
