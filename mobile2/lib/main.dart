import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'navigation/bottom_nav.dart';
import 'pages/get_ready_page.dart';
import 'pages/workout_exercise_page.dart';
import 'pages/search_page.dart';
import 'pages/registration_page.dart';
import 'pages/login_page.dart';
import 'pages/workout_page.dart';
import 'models/workout_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sahabat Bugar - Workout App',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return BottomNav(
              onThemeToggle: _toggleTheme,
              isDarkMode: _isDarkMode,
            );
          }

          return const LoginPage();
        },
      ),
      routes: {
        '/home': (context) =>
            BottomNav(onThemeToggle: _toggleTheme, isDarkMode: _isDarkMode),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/workout': (context) => const WorkoutPage(),
        '/workout-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          
          // Handle both Workout object and Map<String, String>
          if (args is Workout) {
            return WorkoutExercisePage(workout: args);
          } else if (args is Map<String, dynamic>) {
            return WorkoutExercisePage(legacyWorkout: args);
          } else if (args is Map<String, String>) {
            return WorkoutExercisePage(
              legacyWorkout: Map<String, dynamic>.from(args),
            );
          }
          
          return const Scaffold(
            body: Center(
              child: Text('Workout data not found. Please go back and try again.'),
            ),
          );
        },
        '/get-ready': (context) {
          final workout =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, String>?;
          if (workout == null) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Workout data not found. Please go back and try again.',
                ),
              ),
            );
          }
          return GetReadyPage(workout: workout);
        },
        '/workout-exercise': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          
          if (args is Workout) {
            return WorkoutExercisePage(workout: args);
          } else if (args is Map<String, dynamic>) {
            return WorkoutExercisePage(legacyWorkout: args);
          }
          
          return const Scaffold(
            body: Center(
              child: Text(
                'Workout data not found. Please go back and try again.',
              ),
            ),
          );
        },
        '/search': (context) => const SearchPage(),
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF4A6FFF),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF4A6FFF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6FFF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4A6FFF),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: const Color.fromRGBO(158, 158, 158, 0.1),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF4A6FFF),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF4A6FFF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6FFF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4A6FFF),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
