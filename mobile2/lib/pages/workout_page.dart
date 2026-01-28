import 'package:flutter/material.dart';
import '../widgets/level_filter.dart';
import '../widgets/workout_card.dart';
import '../models/workout_model.dart';

class WorkoutPage extends StatefulWidget {
  final String initialLevel;

  const WorkoutPage({super.key, this.initialLevel = 'Semua'});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  String _selectedLevel = 'Semua';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late List<Workout> _allWorkouts;

  @override
  void initState() {
    super.initState();
    _allWorkouts = WorkoutData.getAllWorkouts();
  }

  String _mapLevelToEnglish(String indonesianLevel) {
    switch (indonesianLevel) {
      case 'Semua':
        return 'All';
      case 'Pemula':
        return 'Beginner';
      case 'Menengah':
        return 'Intermediate';
      case 'Lanjutan':
        return 'Advanced';
      default:
        return 'All';
    }
  }

  List<Workout> get _filteredWorkouts {
    List<Workout> filtered = _allWorkouts;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (workout) => workout.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    // Filter by level
    if (_selectedLevel != 'Semua') {
      filtered = filtered
          .where((workout) => workout.level == _selectedLevel)
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temukan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LevelFilter(
              selectedLevel: _selectedLevel,
              onLevelChanged: (level) {
                setState(() {
                  _selectedLevel = level;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_filteredWorkouts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Tidak ada latihan yang sesuai'),
                ),
              )
            else
              ..._filteredWorkouts.map((workout) {
                // Calculate total duration
                int totalSeconds = 0;
                for (var exercise in workout.exercises) {
                  if (exercise.type == 'timer') {
                    totalSeconds += int.tryParse(exercise.duration) ?? 0;
                  } else {
                    // Estimate 3 seconds per rep
                    totalSeconds += (int.tryParse(exercise.reps) ?? 0) * 3;
                  }
                }
                int minutes = (totalSeconds ~/ 60);
                
                return WorkoutCard(
                  title: workout.title,
                  duration: '${minutes} menit',
                  level: workout.level,
                  imagePath: workout.imagePath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/workout-detail',
                      arguments: workout,
                    );
                  },
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
