import 'package:flutter/material.dart';
class MoodDisplay extends StatelessWidget {
  final String mood;

  const MoodDisplay({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.sentiment_very_satisfied, 
              color: Colors.lightGreen,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              'Latest Mood: $mood',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}