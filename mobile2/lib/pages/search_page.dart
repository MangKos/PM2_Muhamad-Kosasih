import 'package:flutter/material.dart';
import '../widgets/workout_card.dart';

/// SearchPage allows users to search through a list of home workouts.
/// It displays a search bar and a filtered list of workout cards.
/// All workouts are designed for home use with minimal or no equipment.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// List of all available home workouts with their details.
  final List<Map<String, String>> _allWorkouts = [
    {
      'title': 'Squat Rumah',
      'duration': '12 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/workout2.jpg',
    },
    {
      'title': 'Push Up Rumah',
      'duration': '6 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/Push up.jpg',
    },
    {
      'title': 'Stretching Pemula Rumah',
      'duration': '10 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/side-plank.jpg',
    },
    {
      'title': 'Pembentukan Perut V Berotot',
      'duration': '20 menit',
      'level': 'Lanjutan',
      'imagePath': 'assets/images/Pembentukan Perut V Berotot.jpg',
    },
    {
      'title': 'Side Plank Rumah',
      'duration': '5 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/side-plank.jpg',
    },
    {
      'title': 'Lunges Rumah',
      'duration': '10 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/Lunges Rumah.jpg',
    },
    {
      'title': 'Stretching Lanjutan Rumah',
      'duration': '15 menit',
      'level': 'Lanjutan',
      'imagePath': 'assets/images/side-plank.jpg',
    },
    {
      'title': 'Push Up Pemula Rumah',
      'duration': '4 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/Push up.jpg',
    },
    {
      'title': 'HIIT Intensif Rumah',
      'duration': '25 menit',
      'level': 'Lanjutan',
      'imagePath': 'assets/images/workout2.jpg',
    },
    {
      'title': 'Squat Jump Rumah',
      'duration': '7 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/Squat Jump.jpg',
    },
    {
      'title': 'Stretching Relaksasi Rumah',
      'duration': '12 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/side-plank.jpg',
    },
    {
      'title': 'Burpees Rumah',
      'duration': '9 menit',
      'level': 'Lanjutan',
      'imagePath': 'assets/images/Burpees Rumah.jpg',
    },
    {
      'title': 'Plank Hold Rumah',
      'duration': '3 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/side-plank.jpg',
    },
    {
      'title': 'Jumping Jacks Rumah',
      'duration': '6 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/workout2.jpg',
    },
    {
      'title': 'Stretching Flow Rumah',
      'duration': '18 menit',
      'level': 'Lanjutan',
      'imagePath': 'assets/images/side-plank.jpg',
    },
    {
      'title': 'Mountain Climbers Rumah',
      'duration': '10 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/high knees workout.jpg',
    },
    {
      'title': 'High Knees Rumah',
      'duration': '5 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/high knees workout.jpg',
    },
    {
      'title': 'Wall Sit Rumah',
      'duration': '8 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/Wall Sit.jpg',
    },
    {
      'title': 'Bridge Rumah',
      'duration': '7 menit',
      'level': 'Pemula',
      'imagePath': 'assets/images/Bridge workout.jpg',
    },
    {
      'title': 'Superman Rumah',
      'duration': '6 menit',
      'level': 'Menengah',
      'imagePath': 'assets/images/Superman.jpg',
    },
  ];

  List<Map<String, String>> get _filteredWorkouts {
    if (_searchQuery.isEmpty) return _allWorkouts;
    return _allWorkouts
        .where(
          (workout) => workout['title']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
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
        title: const Text('Pencarian'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari latihan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _filteredWorkouts.isEmpty
                ? const Center(child: Text('Tidak ada latihan ditemukan'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _filteredWorkouts
                          .map(
                            (workout) => WorkoutCard(
                              title: workout['title']!,
                              duration: workout['duration']!,
                              level: workout['level']!,
                              imagePath: workout['imagePath']!,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/workout-detail',
                                  arguments: workout,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
