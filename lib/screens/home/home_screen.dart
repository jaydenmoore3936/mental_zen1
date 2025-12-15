import 'package:flutter/material.dart';
import '../../widgets/mood_display.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is the implementation of Screen 1
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Zen Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Welcome Message (Screen 1 requirement)
            Text(
              'Welcome back, Jayden!', // Replace with actual user name
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Current State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            // User's most recent mood (Screen 1 requirement)
            const MoodDisplay(
              mood: 'Calm', // Placeholder for latest mood fetched from Firestore
            ),
            const Divider(height: 40),
            // Placeholder for a motivational quote (Use Case requirement)
            const Text(
              '💡 "The best way out is always through." - Robert Frost',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/new_entry'),
              icon: const Icon(Icons.edit_note),
              label: const Text('Start New Journal Entry'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}