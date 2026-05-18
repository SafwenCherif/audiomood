import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mood_history_model.dart';

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
    await _historyCollection(
      history.userId,
    ).doc(history.id).set(history.toJson());
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
