import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/firestore_service.dart';

// Represents the available moods
enum Mood { happy, sad, calm }

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final TextEditingController _entryController = TextEditingController();
  Mood? _selectedMood;
  // Instantiate the service for database operations
  final FirestoreService _firestoreService = FirestoreService();

  // Helper to map Mood to a user-friendly label and icon (Use Case requirement)
  Map<String, dynamic> _getMoodDetails(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return {'label': 'Happy', 'icon': FontAwesomeIcons.faceSmile, 'color': Colors.amber};
      case Mood.sad:
      case Mood.calm:
        return {'label': 'Calm', 'icon': FontAwesomeIcons.faceFlushed, 'color': Colors.green};
      default:
        return {'label': 'N/A', 'icon': FontAwesomeIcons.question, 'color': Colors.grey};
    }
  }

  Future<void> _saveEntry() async {
    final String content = _entryController.text.trim();

    // T6: Attempt to save a blank journal entry
    if (content.isEmpty || _selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Journal content and mood cannot be blank.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop saving
    }

    try {
      // T2: Use the service class to add the entry
      await _firestoreService.addEntry(
        content,
        _selectedMood.toString().split('.').last, // 'happy', 'sad', or 'calm'
      );

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while saving: $e')),
      );
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is the implementation of Screen 2
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Journal Entry'),
        actions: [
          IconButton(
            onPressed: _saveEntry,
            icon: const Icon(Icons.save),
            tooltip: 'Save Entry',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Your Mood:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            // Mood selection buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Mood.values.map((mood) {
                final details = _getMoodDetails(mood);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: _selectedMood == mood
                            ? details['color']
                            : Colors.grey.shade200,
                        child: FaIcon(
                          details['icon'],
                          color: _selectedMood == mood
                            ? Colors.white
                            : details['color'].withOpacity(0.6),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(details['label']),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 40),
            const Text(
              'What are your thoughts?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            // Full-screen editor
            TextField(
              controller: _entryController,
              maxLines: 15, // Allows for detailed entry
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Type your thoughts and feelings here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}