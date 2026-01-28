import 'package:flutter/material.dart';

class LevelFilter extends StatefulWidget {
  final String selectedLevel;
  final ValueChanged<String> onLevelChanged;

  const LevelFilter({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  State<LevelFilter> createState() => _LevelFilterState();
}

class _LevelFilterState extends State<LevelFilter> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Fixed height to ensure proper scrolling
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip('Semua', widget.selectedLevel == 'All'),
          const SizedBox(width: 8),
          _buildChip('Pemula', widget.selectedLevel == 'Beginner'),
          const SizedBox(width: 8),
          _buildChip('Menengah', widget.selectedLevel == 'Intermediate'),
          const SizedBox(width: 8),
          _buildChip('Lanjutan', widget.selectedLevel == 'Advanced'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isActive) {
    return GestureDetector(
      onTap: () => widget.onLevelChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.purple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
