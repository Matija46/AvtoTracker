import 'package:avto_tracker/api_service.dart';
import 'package:avto_tracker/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/account.dart';
import 'pages/trackers.dart';
import 'pages/cars.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://oyprygmqmtgdysbopzcn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95cHJ5Z21xbXRnZHlzYm9wemNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY2MDk2MDksImV4cCI6MjA1MjE4NTYwOX0.vChmiiTsApZKRBEJ72lNncLQ0CSeo29fyw1x81KisjE',
  );
  await Firebase.initializeApp();
  await ApiService().initNotifications();
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

final databaseSupabase = SupabaseClient(
  'https://oyprygmqmtgdysbopzcn.supabase.co/',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95cHJ5Z21xbXRnZHlzYm9wemNuIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNjYwOTYwOSwiZXhwIjoyMDUyMTg1NjA5fQ.q03eizLiEQykh30rXWoBFKViJ1UjM_FHJv51iAUdlEw',
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CarsPage(),
    TrackersPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double multiplier = MediaQuery.sizeOf(context).width/ 411;
    return Scaffold(

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Barve().primaryColor,
        items: <Widget>[
          Icon(
            Icons.directions_car,
            size: 30*multiplier,
            color: Colors.white
          ),
          Icon(
            Icons.track_changes,
            size: 30*multiplier,
            color: Colors.white
          ),
          Icon(
            Icons.account_circle,
            size: 30*multiplier,
            color: Colors.white
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}
