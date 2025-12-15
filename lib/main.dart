import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/journal/journal_entry_screen.dart';
import 'screens/log/mood_tracker_screen.dart';
import 'screens/analytics/insights_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform, 
   );
  
  runApp(const MentalZenApp());
}

class MentalZenApp extends StatelessWidget {
  const MentalZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Zen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.tealAccent,
          background: const Color(0xFFF5F5F5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return MainNavigationScreen(); 
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/home': (context) => MainNavigationScreen(),
        '/new_entry': (context) => const JournalEntryScreen(),
        '/tracker': (context) => MoodTrackerScreen(), 
        '/insights': (context) => InsightsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), 
    MoodTrackerScreen(), 
    InsightsScreen(), 
    SettingsScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onQuickAddPressed() {
    Navigator.of(context).pushNamed('/new_entry');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onQuickAddPressed,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
            const SizedBox(width: 40), 
            IconButton(
              icon: const Icon(Icons.leaderboard),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2 ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _onItemTapped(3),
              color: _selectedIndex == 3 ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}