import 'package:cloud_firestore/cloud_firestore.dart';

class MoodHistoryModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String mood;
  final String previewUrl;
  final Timestamp createdAt;

  const MoodHistoryModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.mood,
    required this.previewUrl,
    required this.createdAt,
  });

  MoodHistoryModel copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? mood,
    String? previewUrl,
    Timestamp? createdAt,
  }) {
    return MoodHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      mood: mood ?? this.mood,
      previewUrl: previewUrl ?? this.previewUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MoodHistoryModel.fromJson(String id, Map<String, dynamic> json) {
    return MoodHistoryModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      mood: json['mood'] as String? ?? '',
      previewUrl: json['previewUrl'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'mood': mood,
      'previewUrl': previewUrl,
      'createdAt': createdAt,
    };
  }
}
