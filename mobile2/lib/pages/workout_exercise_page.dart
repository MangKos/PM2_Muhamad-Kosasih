import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';
import 'appreciation_page.dart';

class WorkoutExercisePage extends StatefulWidget {
  final Workout? workout;
  final Map<String, dynamic>? legacyWorkout;

  const WorkoutExercisePage({
    super.key,
    this.workout,
    this.legacyWorkout,
  });

  @override
  State<WorkoutExercisePage> createState() => _WorkoutExercisePageState();
}

class _WorkoutExercisePageState extends State<WorkoutExercisePage>
    with TickerProviderStateMixin {
  Timer? _timer;
  bool _isPaused = false;
  bool _isStarted = false;
  int _elapsedSeconds = 0;
  int _remainingSeconds = 15;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late int _currentExerciseIndex;
  late List<Exercise> _exercises;
  late Workout _currentWorkout;
  int _repsCompleted = 0;
  double _totalCaloriesBurned = 0.0;

  @override
  void initState() {
    super.initState();
    
    try {
      // Handle both new Workout object and legacy Map format
      if (widget.workout != null) {
        _currentWorkout = widget.workout!;
        _exercises = widget.workout!.exercises;
      } else if (widget.legacyWorkout != null) {
        // Create a simple workout from legacy data
        final Map<String, dynamic> args = widget.legacyWorkout!;
        _exercises = [
          Exercise(
            title: args['title'] ?? 'Unknown',
            type: 'timer',
            duration: '15',
            reps: '0',
            description: '',
            imagePath: args['imagePath'] ?? 'assets/images/workout2.jpg',
            level: args['level'] ?? 'Menengah',
          ),
        ];
        _currentWorkout = Workout(
          title: args['title'] ?? 'Unknown',
          level: args['level'] ?? 'Menengah',
          imagePath: args['imagePath'] ?? 'assets/images/workout2.jpg',
          exercises: _exercises,
        );
      } else {
        _exercises = [];
        _currentWorkout = Workout(
          title: 'Unknown',
          level: 'Menengah',
          imagePath: 'assets/images/workout2.jpg',
          exercises: [],
        );
      }

      _currentExerciseIndex = 0;

      // Set initial timer based on first exercise
      if (_exercises.isNotEmpty) {
        final type = _exercises[_currentExerciseIndex].type;
        if (type == 'timer') {
          _remainingSeconds = int.parse(_exercises[_currentExerciseIndex].duration);
        } else {
          _remainingSeconds = 0;
        }
      }

      _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    } catch (e) {
      print('Error in WorkoutExercisePage initState: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    // Check if reps-based exercise
    if (_exercises[_currentExerciseIndex].type == 'reps') {
      // For reps-based, just mark as started
      setState(() {
        _isStarted = true;
        _repsCompleted = 0;
      });
      _animationController.forward();
    } else {
      // Timer-based exercise
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            _elapsedSeconds++;
          } else {
            _timer?.cancel();
            _goToNextExercise();
          }
        });
      });
    }
  }

  void _goToNextExercise() {
    if (_currentExerciseIndex >= _exercises.length - 1) {
      // All exercises completed
      _saveWorkoutProgress().then((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AppreciationPage(
                workout: _exercises.last.toMap(),
              ),
            ),
          );
        }
      });
    } else {
      setState(() {
        _currentExerciseIndex++;
        final type = _exercises[_currentExerciseIndex].type;
        if (type == 'timer') {
          _remainingSeconds = int.parse(_exercises[_currentExerciseIndex].duration);
        } else {
          _remainingSeconds = 0;
        }
        _elapsedSeconds = 0;
        _repsCompleted = 0;
        _isPaused = false;
        _isStarted = false;
      });
      _animationController.reset();
    }
  }

  void _goToNextExerciseAfterReps() {
    if (_currentExerciseIndex >= _exercises.length - 1) {
      // All exercises completed
      _saveWorkoutProgress().then((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AppreciationPage(
                workout: _exercises.last.toMap(),
              ),
            ),
          );
        }
      });
    } else {
      setState(() {
        _currentExerciseIndex++;
        final type = _exercises[_currentExerciseIndex].type;
        if (type == 'timer') {
          _remainingSeconds = int.parse(_exercises[_currentExerciseIndex].duration);
        } else {
          _remainingSeconds = 0;
        }
        _elapsedSeconds = 0;
        _repsCompleted = 0;
        _isPaused = false;
        _isStarted = false;
      });
      _animationController.reset();
    }
  }

  void _goToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        final type = _exercises[_currentExerciseIndex].type;
        if (type == 'timer') {
          _remainingSeconds = int.parse(_exercises[_currentExerciseIndex].duration);
        } else {
          _remainingSeconds = 0;
        }
        _elapsedSeconds = 0;
        _repsCompleted = 0;
        _isPaused = false;
        _isStarted = false;
      });
      _animationController.reset();
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _timer?.cancel();
      _animationController.reverse();
    } else {
      _startTimer();
      _animationController.forward();
    }
  }

  void _startWorkout() {
    setState(() {
      _isStarted = true;
    });
    _startTimer();
    _animationController.forward();
  }

  double _calculateCalories() {
    // Simple calorie calculation based on workout type and time
    double baseCaloriesPerMinute = 5.0; // Default
    
    if (_exercises.isEmpty || _currentExerciseIndex >= _exercises.length) {
      return 0.0;
    }
    
    String workoutType = (_exercises[_currentExerciseIndex].title).toLowerCase();

    if (workoutType.contains('hiit') ||
        workoutType.contains('run') ||
        workoutType.contains('jump') ||
        workoutType.contains('burpee') ||
        workoutType.contains('sprint') ||
        workoutType.contains('plyometric')) {
      baseCaloriesPerMinute = 8.0;
    } else if (workoutType.contains('strength') ||
        workoutType.contains('weight') ||
        workoutType.contains('dumbbell') ||
        workoutType.contains('push up') ||
        workoutType.contains('squat') ||
        workoutType.contains('row')) {
      baseCaloriesPerMinute = 6.0;
    } else if (workoutType.contains('stretching') ||
        workoutType.contains('yoga') ||
        workoutType.contains('plank') ||
        workoutType.contains('stretch')) {
      baseCaloriesPerMinute = 3.0;
    } else if (workoutType.contains('cardio') ||
        workoutType.contains('interval') ||
        workoutType.contains('climb') ||
        workoutType.contains('rope') ||
        workoutType.contains('jack')) {
      baseCaloriesPerMinute = 7.5;
    }

    return (_elapsedSeconds / 60.0) * baseCaloriesPerMinute;
  }

  Future<void> _saveWorkoutProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing workout data
    List<String> completedWorkouts =
        prefs.getStringList('completed_workouts') ?? [];
    double totalCalories = prefs.getDouble('total_calories') ?? 0.0;
    int totalWorkouts = prefs.getInt('total_workouts') ?? 0;
    int totalMinutes = prefs.getInt('total_minutes') ?? 0;

    // Calculate total calories for all completed exercises
    double caloriesForWorkout = 0.0;
    int totalMinutesForWorkout = 0;

    for (int i = 0; i < _exercises.length; i++) {
      final exercise = _exercises[i];
      int exerciseDurationSeconds = 0;
      
      if (exercise.type == 'timer') {
        exerciseDurationSeconds = int.parse(exercise.duration);
      } else if (exercise.type == 'reps') {
        // Estimate 3 seconds per rep
        exerciseDurationSeconds = int.parse(exercise.reps) * 3;
      }

      // Calculate calories for this exercise
      double baseCaloriesPerMinute = 5.0;
      final title = exercise.title.toLowerCase();
      
      if (title.contains('hiit') || title.contains('run') || title.contains('jump') ||
          title.contains('burpee') || title.contains('sprint') || title.contains('plyometric')) {
        baseCaloriesPerMinute = 8.0;
      } else if (title.contains('strength') || title.contains('weight') || title.contains('dumbbell') ||
                 title.contains('push up') || title.contains('squat') || title.contains('row')) {
        baseCaloriesPerMinute = 6.0;
      } else if (title.contains('stretching') || title.contains('yoga') || title.contains('plank') ||
                 title.contains('stretch')) {
        baseCaloriesPerMinute = 3.0;
      } else if (title.contains('cardio') || title.contains('interval') || title.contains('climb') ||
                 title.contains('rope') || title.contains('jack')) {
        baseCaloriesPerMinute = 7.5;
      }

      caloriesForWorkout += (exerciseDurationSeconds / 60.0) * baseCaloriesPerMinute;
      totalMinutesForWorkout += exerciseDurationSeconds ~/ 60;
    }

    // Update totals
    totalCalories += caloriesForWorkout;
    totalWorkouts += 1;
    totalMinutes += totalMinutesForWorkout;

    // Add current workout to completed list
    String workoutEntry =
        '${_currentWorkout.title}|${DateTime.now().toIso8601String()}|${caloriesForWorkout.toStringAsFixed(2)}|$totalMinutesForWorkout';
    completedWorkouts.add(workoutEntry);

    // Save to SharedPreferences
    await prefs.setStringList('completed_workouts', completedWorkouts);
    await prefs.setDouble('total_calories', totalCalories);
    await prefs.setInt('total_workouts', totalWorkouts);
    await prefs.setInt('total_minutes', totalMinutes);
    await prefs.setInt(
      'last_workout_date',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    // Handle empty exercises list
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Latihan')),
        body: const Center(
          child: Text('Tidak ada latihan tersedia'),
        ),
      );
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    final isTimerBased = currentExercise.type == 'timer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Exercise Counter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6FFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Latihan ${_currentExerciseIndex + 1} dari ${_exercises.length}',
                    style: const TextStyle(
                      color: Color(0xFF4A6FFF),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),

                SizedBox(height: screenSize.height * 0.02),

                // Workout Image
                Container(
                  height: screenSize.height * 0.25,
                  width: double.infinity,
                  child: Image.asset(
                    currentExercise.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: screenSize.height * 0.02),

                // Workout Title
                Text(
                  currentExercise.title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenSize.height * 0.01),

                // Workout Level
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6FFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    currentExercise.level,
                    style: const TextStyle(
                      color: Color(0xFF4A6FFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: screenSize.height * 0.03),

                // Display Timer or Reps based on exercise type
                if (isTimerBased)
                  Column(
                    children: [
                      Text(
                        'Durasi',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      // Timer Display
                      Text(
                        '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 32 : 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A6FFF),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Text(
                        'Target Repetisi',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      // Reps Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A6FFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${currentExercise.reps} repetisi',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A6FFF),
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: screenSize.height * 0.03),

                // Control Buttons
                if (!_isStarted)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton.icon(
                      onPressed: _startWorkout,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('MULAI LATIHAN'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.08,
                          vertical: screenSize.height * 0.015,
                        ),
                        backgroundColor: const Color(0xFF4A6FFF),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      if (isTimerBased)
                        ElevatedButton.icon(
                          onPressed: _togglePause,
                          icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                          label: Text(_isPaused ? 'LANJUTKAN' : 'JEDA'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.08,
                              vertical: screenSize.height * 0.015,
                            ),
                            backgroundColor: const Color(0xFF4A6FFF),
                            foregroundColor: Colors.white,
                          ),
                        )
                      else
                        // For reps-based exercises, show "Selesai" button
                        ElevatedButton.icon(
                          onPressed: () {
                            _goToNextExerciseAfterReps();
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('SELESAI REPS'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.08,
                              vertical: screenSize.height * 0.015,
                            ),
                            backgroundColor: const Color(0xFF4A6FFF),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      SizedBox(height: screenSize.height * 0.02),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.stop),
                        label: const Text('STOP'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.08,
                            vertical: screenSize.height * 0.015,
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: screenSize.height * 0.03),

                // Stats Display
                if (_isStarted)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.local_fire_department,
                            value: _calculateCalories().toStringAsFixed(1),
                            unit: 'kcal',
                            color: Colors.orange,
                          ),
                          SizedBox(width: screenSize.width * 0.04),
                          _StatItem(
                            icon: Icons.timer,
                            value: '${(_elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
                            unit: 'waktu',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: screenSize.height * 0.03),

                // Navigation Buttons for Multiple Exercises
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _currentExerciseIndex > 0 ? _goToPreviousExercise : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Sebelumnya'),
                    ),
                    if (_exercises.length > 1)
                      Text(
                        '${_currentExerciseIndex + 1}/${_exercises.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    TextButton.icon(
                      onPressed: _currentExerciseIndex < _exercises.length - 1 ? _goToNextExercise : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Selanjutnya'),
                    ),
                  ],
                ),

                SizedBox(height: screenSize.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for displaying stats
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
