import 'package:flutter/material.dart';
import 'workout_exercise_page.dart';
import '../widgets/timer_circle.dart';
import '../models/workout_model.dart';

class GetReadyPage extends StatelessWidget {
  final dynamic workout; // Can be Workout or Map<String, String>

  const GetReadyPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Get Ready!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 24),
            TimerCircle(
              seconds: 9,
              onTimerComplete: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      if (workout is Workout) {
                        return WorkoutExercisePage(workout: workout);
                      } else {
                        return WorkoutExercisePage(legacyWorkout: workout);
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      if (workout is Workout) {
                        return WorkoutExercisePage(workout: workout);
                      } else {
                        return WorkoutExercisePage(legacyWorkout: workout);
                      }
                    },
                  ),
                );
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
