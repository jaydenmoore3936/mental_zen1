import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String content;
  final String mood; 
  final DateTime timestamp;

  JournalEntry({
    required this.id,
    required this.content,
    required this.mood,
    required this.timestamp,
  });

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    final Timestamp firestoreTimestamp = data['timestamp'] as Timestamp;

    return JournalEntry(
      id: doc.id,
      content: data['content'] ?? '',
      mood: data['mood'] ?? 'unknown',
      timestamp: firestoreTimestamp.toDate(),
    );
  }
}