// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _userName;
  late String _userInitial;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userName = prefs.getString('user_name') ?? 'admin';
        _userInitial =
            prefs.getString('user_name')?.substring(0, 1).toUpperCase() ?? 'C';
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _userName = 'admin';
        _userInitial = 'A';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDay = _getTimeOfDay();
    final greeting = _getGreeting(timeOfDay);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get first beginner workout as quick workout
          final allWorkouts = WorkoutData.getAllWorkouts();
          final beginnerWorkout = allWorkouts.firstWhere(
            (w) => w.level == 'Pemula',
            orElse: () => allWorkouts.first,
          );
          Navigator.pushNamed(
            context,
            '/workout-detail',
            arguments: beginnerWorkout,
          );
        },
        backgroundColor: const Color(0xFF4A6FFF),
        child: const Icon(Icons.play_arrow),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan sapaan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Profile picture
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A6FFF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          _userInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Latihan Unggulan Section - Horizontal Scrollable
                _buildFeaturedWorkoutSection(context),
                const SizedBox(height: 24),

                // Tingkatan Latihan Section - List
                _buildWorkoutLevelsSection(context),
                const SizedBox(height: 24),

                // Semua Latihan Section - List dengan gambar di samping
                _buildAllWorkoutsSection(context),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk Latihan Unggulan Section
  Widget _buildFeaturedWorkoutSection(BuildContext context) {
    final allWorkouts = WorkoutData.getAllWorkouts();
    final featuredWorkouts = allWorkouts.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latihan Unggulan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () {
                // Navigate to workout page to see all workouts
                Navigator.pushNamed(context, '/workout');
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF4A6FFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Scrollable Cards
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredWorkouts.length,
            itemBuilder: (context, index) {
              final workout = featuredWorkouts[index];
              final colors = [
                const Color(0xFF4A6FFF),
                Colors.green,
                Colors.red,
              ];
              final color = colors[index % colors.length];

              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index == featuredWorkouts.length - 1 ? 0 : 16,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            color: color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.layers,
                                    color: color,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${workout.exercises.length} latihan',
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      workout.level,
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        _getWorkoutDescription(workout.title),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/workout-detail',
                            arguments: workout,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Mulai'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget untuk Tingkatan Latihan Section (List)
  Widget _buildWorkoutLevelsSection(BuildContext context) {
    final levels = [
      _WorkoutLevel(
        name: 'Pemula',
        description: 'Untuk yang baru mulai berolahraga',
        icon: Icons.arrow_upward,
        color: Colors.green,
        workoutCount: 12,
      ),
      _WorkoutLevel(
        name: 'Menengah',
        description: 'Latihan dengan intensitas sedang',
        icon: Icons.trending_up,
        color: Colors.blue,
        workoutCount: 24,
      ),
      _WorkoutLevel(
        name: 'Lanjutan',
        description: 'Latihan intens untuk berpengalaman',
        icon: Icons.bolt,
        color: Colors.red,
        workoutCount: 8,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tingkatan Latihan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () {
                // Navigate to workout page to see all workouts
                Navigator.pushNamed(context, '/workout');
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF4A6FFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: levels.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final level = levels[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: level.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(level.icon, color: level.color, size: 24),
                ),
                title: Text(
                  level.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      level.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${level.workoutCount} latihan tersedia',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/workout');
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // Widget untuk Semua Latihan Section (List dengan gambar di samping)
  Widget _buildAllWorkoutsSection(BuildContext context) {
    final allWorkouts = WorkoutData.getAllWorkouts();
    final workouts = allWorkouts.map((w) {
      return _WorkoutItem(
        title: w.title,
        duration: '${w.exercises.length} latihan',
        level: w.level,
        color: Colors.orange,
        icon: Icons.directions_run,
      );
    }).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latihan Populer', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final workout = workouts[index];
            final allWorkoutsList = WorkoutData.getAllWorkouts();
            final fullWorkout = allWorkoutsList[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: workout.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(workout.icon, color: workout.color, size: 28),
                ),
                title: Text(
                  workout.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.layers, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          workout.duration,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        workout.level,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: workout.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/workout-detail',
                        arguments: fullWorkout,
                      );
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Helper function untuk mendapatkan deskripsi workout
  String _getWorkoutDescription(String title) {
    switch (title) {
      case 'Latihan Tubuh Penuh':
        return 'Latihan komprehensif untuk seluruh tubuh dengan 12 gerakan berbeda, mencakup cardio dan strength training.';
      case 'Gerakan Squat':
        return 'Program khusus squat dengan 12 variasi untuk mengembangkan kekuatan kaki dan glute secara maksimal.';
      case 'Latihan Push Up':
        return 'Latihan push up progresif dengan 11 variasi berbeda untuk chest, shoulders, dan triceps.';
      case 'Latihan Dumbbell':
        return 'Program dumbbell dengan 12 latihan untuk melatih semua otot besar tubuh Anda.';
      case 'Stretching Pemula':
        return 'Latihan stretching lengkap untuk pemula dengan 12 gerakan untuk meningkatkan fleksibilitas.';
      case 'Cardio Lanjutan':
        return 'Program cardio intensif dengan 13 latihan HIIT untuk pembakaran kalori maksimal.';
      default:
        return 'Latihan yang dirancang khusus untuk meningkatkan kebugaran dan kesehatan tubuh secara menyeluruh.';
    }
  }

  // Helper function untuk mendapatkan waktu dalam hari
  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Pagi';
    if (hour < 17) return 'Siang';
    if (hour < 21) return 'Sore';
    return 'Malam';
  }

  Future<Map<String, dynamic>> _loadProgressData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'totalCalories': prefs.getDouble('total_calories') ?? 0.0,
      'totalWorkouts': prefs.getInt('total_workouts') ?? 0,
      'totalMinutes': prefs.getInt('total_minutes') ?? 0,
    };
  }

  // Helper function untuk mendapatkan greeting
  String _getGreeting(String timeOfDay) {
    switch (timeOfDay) {
      case 'Pagi':
        return 'Selamat Pagi';
      case 'Siang':
        return 'Selamat Siang';
      case 'Sore':
        return 'Selamat Sore';
      default:
        return 'Selamat Malam';
    }
  }
}

// Model untuk Latihan Unggulan
class _FeaturedWorkout {
  final String title;
  final String duration;
  final String level;
  final Color color;
  final IconData icon;

  const _FeaturedWorkout({
    required this.title,
    required this.duration,
    required this.level,
    required this.color,
    required this.icon,
  });
}

// Model untuk Tingkatan Latihan
class _WorkoutLevel {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int workoutCount;

  const _WorkoutLevel({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.workoutCount,
  });
}

// Model untuk Latihan Item
class _WorkoutItem {
  final String title;
  final String duration;
  final String level;
  final Color color;
  final IconData icon;

  const _WorkoutItem({
    required this.title,
    required this.duration,
    required this.level,
    required this.color,
    required this.icon,
  });
}

// Widget untuk Progress Stat
class _ProgressStat extends StatelessWidget {
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _ProgressStat({
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(unit, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
