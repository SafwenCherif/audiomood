import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/cloudinary_service.dart';
import '../../core/services/firestore_service.dart';
import '../../models/mood_history_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

final moodHistoryStreamProvider =
    StreamProvider.family<List<MoodHistoryModel>, String>((ref, userId) {
      return ref.watch(firestoreServiceProvider).streamHistory(userId);
    });
