import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _setWellnessReminder(BuildContext context) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reminder setup UI needs to be implemented. (T5)'),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  // Handles the user logging out
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen after logging out
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is the implementation of Screen 5: Settings/Reminders
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile'),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Profile/Privacy Settings (Screen 5 requirement)
          ListTile(
            leading: const Icon(Icons.person, color: Colors.indigo),
            title: const Text('Manage Profile & Privacy'),
            subtitle: const Text('Review your profile and privacy settings'),
            onTap: () { 
              // Future implementation: Navigate to a profile management screen 
            },
          ),
          const Divider(),
          // Customizable daily wellness reminders (Screen 5 requirement)
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.teal),
            title: const Text('Wellness Reminders'),
            subtitle: const Text('Set up customizable daily self-care reminders (T5)'),
            onTap: () => _setWellnessReminder(context),
          ),
          const Divider(),
          // Logout functionality
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}