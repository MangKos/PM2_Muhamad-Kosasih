import 'package:flutter/material.dart';

class WorkoutActivityItem extends StatelessWidget {
  final String title;
  final String duration;

  const WorkoutActivityItem({
    super.key,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      title: Text(title),
      subtitle: Text(duration),
    );
  }
}
