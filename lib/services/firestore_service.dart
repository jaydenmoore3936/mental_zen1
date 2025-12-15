import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

   FirestoreService();

  CollectionReference? get _entriesCollection {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return _firestore.collection('users').doc(user.uid).collection('entries');
  }

  Future<void> addEntry(String content, String mood) async {
    final collection = _entriesCollection;
    if (collection == null) return;

    await collection.add({
      'content': content,
      'mood': mood,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateEntry(String entryId, String content, String mood) async {
    final collection = _entriesCollection;
    if (collection == null) return;

    await collection.doc(entryId).update({
      'content': content,
      'mood': mood,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<JournalEntry>> getEntriesStream() {
    final collection = _entriesCollection;
    if (collection == null) {
      return Stream.value([]);
    }
    return collection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => JournalEntry.fromFirestore(doc)).toList();
    });
  }

  // Implementation for Must-Solve Challenge 3
  Future<Map<String, int>> getMoodFrequency(int days) async {
    final collection = _entriesCollection;
    if (collection == null) return {};

    final DateTime startDate = DateTime.now().subtract(Duration(days: days));
    final Timestamp startTimestamp = Timestamp.fromDate(startDate);

    final querySnapshot = await collection
        .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
        .get();

    final Map<String, int> moodCounts = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final mood = data['mood'] as String? ?? 'unknown';
      
      moodCounts.update(mood, (value) => value + 1, ifAbsent: () => 1);
    }
    
    return moodCounts;
  }
}