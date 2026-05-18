import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/cloudinary_service.dart';
import '../../core/services/firestore_service.dart';
import '../../models/mood_history_model.dart';
import 'mood_history_repository.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

final moodHistoryRepositoryProvider = Provider<MoodHistoryRepository>((ref) {
  return MoodHistoryRepository(
    firestoreService: ref.watch(firestoreServiceProvider),
    cloudinaryService: ref.watch(cloudinaryServiceProvider),
  );
});

final moodHistoryStreamProvider =
    StreamProvider.family<List<MoodHistoryModel>, String>((ref, userId) {
      return ref.watch(moodHistoryRepositoryProvider).streamHistory(userId);
    });
