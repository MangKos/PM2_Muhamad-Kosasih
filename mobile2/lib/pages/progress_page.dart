// lib/pages/progress_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;
  late List<List<int>> _calendarGrid;

  // Fitness progress data
  double _totalCalories = 0.0;
  int _totalWorkouts = 0;
  int _totalMinutes = 0;
  List<Map<String, dynamic>> _completedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _generateCalendar();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _totalCalories = prefs.getDouble('total_calories') ?? 0.0;
      _totalWorkouts = prefs.getInt('total_workouts') ?? 0;
      _totalMinutes = prefs.getInt('total_minutes') ?? 0;

      // Load completed workouts
      List<String> workoutStrings =
          prefs.getStringList('completed_workouts') ?? [];
      _completedWorkouts = workoutStrings.map((workoutString) {
        List<String> parts = workoutString.split('|');
        return {
          'title': parts[0],
          'date': DateTime.parse(parts[1]),
          'calories': double.parse(parts[2]),
          'minutes': int.parse(parts[3]),
        };
      }).toList();
    });
  }

  void _generateCalendar() {
    final firstDay = _currentMonth;
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Hari pertama bulan ini
    final startingWeekday = firstDay.weekday;

    // Total hari dalam bulan
    final totalDays = lastDay.day;

    // Generate grid kalender
    _calendarGrid = [];
    List<int> week = [];

    // Tambahkan hari kosong untuk minggu pertama
    for (int i = 1; i < startingWeekday; i++) {
      week.add(0);
    }

    // Tambahkan hari-hari bulan ini
    for (int day = 1; day <= totalDays; day++) {
      week.add(day);
      if (week.length == 7) {
        _calendarGrid.add([...week]);
        week.clear();
      }
    }

    // Tambahkan hari kosong untuk minggu terakhir
    if (week.isNotEmpty) {
      while (week.length < 7) {
        week.add(0);
      }
      _calendarGrid.add(week);
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _generateCalendar();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _generateCalendar();
    });
  }

  void _selectDate(int day) {
    if (day > 0) {
      setState(() {
        _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format bulan dan tahun untuk header
    final monthYear = _formatMonthYear(_currentMonth);

    return Scaffold(
      backgroundColor: Colors.white,
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
                // Header
                const Text(
                  'Progress',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Calendar Section
                Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF5F5F7,
                    ), // Warna abu-abu muda dari gambar
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month Header with Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _previousMonth,
                            icon: const Icon(Icons.chevron_left),
                            color: Colors.black,
                          ),
                          Text(
                            monthYear,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: _nextMonth,
                            icon: const Icon(Icons.chevron_right),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Days of Week Header
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _DayLabel(label: 'M'),
                          _DayLabel(label: 'T'),
                          _DayLabel(label: 'W'),
                          _DayLabel(label: 'T'),
                          _DayLabel(label: 'F'),
                          _DayLabel(label: 'S'),
                          _DayLabel(label: 'S'),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Calendar Grid
                      ..._calendarGrid.map((week) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: week.map((day) {
                              final isToday =
                                  day == DateTime.now().day &&
                                  _currentMonth.month == DateTime.now().month &&
                                  _currentMonth.year == DateTime.now().year;
                              final isSelected =
                                  day == _selectedDate.day &&
                                  _currentMonth.month == _selectedDate.month;

                              return GestureDetector(
                                onTap: () => _selectDate(day),
                                child: _CalendarDay(
                                  day: day,
                                  isToday: isToday,
                                  isSelected: isSelected,
                                  isCurrentMonth: day > 0,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Buat responsif berdasarkan lebar layar
                    final isSmallScreen = constraints.maxWidth < 350;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _StatCard(
                                value: _totalCalories.toStringAsFixed(0),
                                unit: 'Cal',
                                icon: Icons.local_fire_department,
                                iconColor: Colors.orange,
                                isSmall: isSmallScreen,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Expanded(
                              child: _StatCard(
                                value: _totalMinutes.toString(),
                                unit: 'Min',
                                icon: Icons.timer,
                                iconColor: const Color(0xFF4A6FFF),
                                isSmall: isSmallScreen,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Expanded(
                              child: _StatCard(
                                value: '72',
                                unit: 'bpm',
                                icon: Icons.favorite,
                                iconColor: Colors.red,
                                isSmall: isSmallScreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Additional Stat Card for Workouts
                        _StatCard(
                          value: _totalWorkouts.toString(),
                          unit: 'Workouts',
                          icon: Icons.fitness_center,
                          iconColor: Colors.green,
                          isSmall: isSmallScreen,
                          isFullWidth: true,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Recent Workouts Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Workouts',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all workouts
                      },
                      child: const Text(
                        'See All',
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

                // Recent Workout Cards - Show actual completed workouts
                if (_completedWorkouts.isNotEmpty)
                  ..._completedWorkouts.take(3).map((workout) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A6FFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: Color(0xFF4A6FFF),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout['title'] as String,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${workout['minutes']} minutes | ${(workout['calories'] as double).toStringAsFixed(1)} Cal',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Finished',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                else
                  // Show placeholder when no workouts completed
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text(
                        'Belum ada latihan yang diselesaikan',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),

                // Spacer untuk memberikan ruang di bawah
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'In Progress',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }
}

// Widget for calendar day label
class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Widget for calendar day
class _CalendarDay extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool isCurrentMonth;

  const _CalendarDay({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.isCurrentMonth,
  });

  @override
  Widget build(BuildContext context) {
    if (day == 0) {
      return const SizedBox(width: 36, height: 36);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4A6FFF)
            : isToday
            ? const Color(0xFF4A6FFF).withOpacity(0.1)
            : Colors.transparent,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: const Color(0xFF4A6FFF), width: 1.5)
            : null,
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isCurrentMonth
                ? Colors.black
                : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected || isToday
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Widget for stat cards
class _StatCard extends StatelessWidget {
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final bool isSmall;
  final bool isFullWidth;

  const _StatCard({
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    this.isSmall = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFullWidth) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: isSmall ? 20 : 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isSmall ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isSmall ? 12 : 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(isSmall ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: isSmall ? 20 : 24),
              SizedBox(width: isSmall ? 6 : 8),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isSmall ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmall ? 4 : 8),
          Text(
            unit,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isSmall ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
