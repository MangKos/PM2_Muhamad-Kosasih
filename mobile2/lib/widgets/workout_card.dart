import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String duration;
  final String level;
  final String imagePath;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.level,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust height based on screen size for better mobile experience
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth < 600 ? 120.0 : 160.0; // Smaller on mobile

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(duration, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(width: 8),
                  Text(level, style: const TextStyle(color: Colors.white70)),
                  const Spacer(),
                  const Icon(Icons.bookmark_border, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
