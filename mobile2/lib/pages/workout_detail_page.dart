import 'package:flutter/material.dart';
import 'get_ready_page.dart';
import '../widgets/workout_activity_item.dart';

class WorkoutDetailPage extends StatelessWidget {
  final Map<String, String>? workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Workout data not found. Please go back and try again.'),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  workout!['imagePath']!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout!['title']!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoChip(label: workout!['level']!),
                        _InfoChip(label: workout!['duration']!),
                        _InfoChip(label: '10 workout'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Workout Activity',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text('See All', style: TextStyle(color: Colors.purple)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: const [
                          WorkoutActivityItem(
                            title: 'Warrior 1',
                            duration: '30 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Side Plank',
                            duration: '20 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Push Up',
                            duration: '15 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Squat Jump',
                            duration: '25 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Burpees',
                            duration: '40 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Mountain Climber',
                            duration: '30 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Plank Hold',
                            duration: '60 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'High Knees',
                            duration: '20 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Lunges',
                            duration: '30 seconds',
                          ),
                          WorkoutActivityItem(
                            title: 'Bridge',
                            duration: '25 seconds',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GetReadyPage(workout: workout!),
                            ),
                          );
                        },
                        child: const Text('START'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label),
    );
  }
}
