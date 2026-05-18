import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mood_history_model.dart';
import '../network/network_service.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _historyCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('mood_history');
  }

  Future<void> addHistory(MoodHistoryModel history) async {
    try {
      await _historyCollection(history.userId)
          .doc(history.id)
          .set(history.toJson())
          .timeout(NetworkService.defaultTimeout);
    } catch (e) {
      throw NetworkService.from(e);
    }
  }

  Future<void> deleteHistory(String userId, String historyId) async {
    try {
      await _historyCollection(userId)
          .doc(historyId)
          .delete()
          .timeout(NetworkService.defaultTimeout);
    } catch (e) {
      throw NetworkService.from(e);
    }
  }

  Stream<List<MoodHistoryModel>> streamHistory(String userId) {
    return _historyCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MoodHistoryModel.fromJson(doc.id, doc.data()))
              .toList(),
        );
  }
}
