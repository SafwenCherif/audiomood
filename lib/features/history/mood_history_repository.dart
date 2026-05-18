import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/cloudinary_service.dart';
import '../../core/services/firestore_service.dart';
import '../../models/mood_history_model.dart';

class MoodHistoryRepository {
  MoodHistoryRepository({
    required FirestoreService firestoreService,
    required CloudinaryService cloudinaryService,
  }) : _firestoreService = firestoreService,
       _cloudinaryService = cloudinaryService;

  final FirestoreService _firestoreService;
  final CloudinaryService _cloudinaryService;

  Future<String> uploadImage(String filePath) async {
    return _cloudinaryService.uploadImage(filePath);
  }

  Future<void> saveHistory(MoodHistoryModel history) async {
    await _firestoreService.addHistory(history);
  }

  Stream<List<MoodHistoryModel>> streamHistory(String userId) {
    return _firestoreService.streamHistory(userId);
  }

  MoodHistoryModel buildHistory({
    required String userId,
    required String imageUrl,
    required String mood,
    required String previewUrl,
  }) {
    return MoodHistoryModel(
      id: FirebaseFirestore.instance.collection('tmp').doc().id,
      userId: userId,
      imageUrl: imageUrl,
      mood: mood,
      previewUrl: previewUrl,
      createdAt: Timestamp.now(),
    );
  }
}
