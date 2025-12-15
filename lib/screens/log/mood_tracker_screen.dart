import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/journal_entry.dart';
import '../../services/firestore_service.dart';

class MoodTrackerScreen extends StatelessWidget {
  MoodTrackerScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  Map<String, dynamic> _getMoodStyle(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return {'icon': FontAwesomeIcons.faceSmile, 'color': Colors.amber[700]};
      case 'sad':
        return {'icon': FontAwesomeIcons.faceFrown, 'color': Colors.blue[700]};
      case 'calm':
        return {'icon': FontAwesomeIcons.faceFlushed, 'color': Colors.green[700]};
      default:
        return {'icon': Icons.help_outline, 'color': Colors.grey};
    }
  }

  void _editEntry(BuildContext context, JournalEntry entry) {
    // Tapping an entry opens the edit view (T3 implementation starts here).
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening editor for entry on ${DateFormat.yMd().format(entry.timestamp)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker Log'),
        elevation: 1,
      ),
      body: StreamBuilder<List<JournalEntry>>(
        stream: _firestoreService.getEntriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading entries: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No journal entries logged yet.\nTap the + button to start!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final entries = snapshot.data!;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final style = _getMoodStyle(entry.mood);

              return Card(
                elevation: 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: style['color'],
                    child: FaIcon(style['icon'], color: Colors.white, size: 20),
                  ),
                  title: Text(
                    DateFormat('EEEE, MMM d, y').format(entry.timestamp),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                  onTap: () => _editEntry(context, entry),
                ),
              );
            },
          );
        },
      ),
    );
  }
}