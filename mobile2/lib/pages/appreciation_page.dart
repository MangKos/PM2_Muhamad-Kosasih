import 'package:flutter/material.dart';
import '../navigation/bottom_nav.dart';

class AppreciationPage extends StatelessWidget {
  final Map<String, String>? workout;

  const AppreciationPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.celebration,
                  size: 80,
                  color: Color(0xFF4A6FFF),
                ),
                const SizedBox(height: 20),
                Text(
                  'Selamat!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF4A6FFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Anda telah menyelesaikan latihan ${workout!['title']}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Kerja bagus! Terus jaga kesehatan Anda.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to home and show progress tab
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // Show snackbar to guide user to progress tab
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Ketuk tab "Progress" untuk melihat perkembangan Anda!',
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
