import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/workout_page.dart';
import '../pages/progress_page.dart';
import '../pages/profile_page.dart';

class BottomNav extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;

  const BottomNav({super.key, this.onThemeToggle, this.isDarkMode = false});

  // Global key to access BottomNav state from outside
  static final GlobalKey<_BottomNavState> globalKey =
      GlobalKey<_BottomNavState>();

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const WorkoutPage(),
      const ProgressPage(),
      ProfilePage(
        isDarkMode: widget.isDarkMode,
        onThemeToggle: widget.onThemeToggle,
      ),
    ];
  }

  @override
  void didUpdateWidget(BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _pages[3] = ProfilePage(
        isDarkMode: widget.isDarkMode,
        onThemeToggle: widget.onThemeToggle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Latihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
