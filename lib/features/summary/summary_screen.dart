import 'package:flutter/material.dart';
import 'package:poems_planks/app/app.dart';
import 'package:poems_planks/core/theme/app_theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({
    super.key,
    required this.result,
    required this.onAgain,
  });

  final WorkoutResult result;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Держалось.',
                style: TextStyle(fontSize: 42, color: AppTheme.paper),
              ),
              const SizedBox(height: 8),
              Text(
                '${result.poemTitle} · ${result.poemAuthor}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  _stat('${result.plankSeconds}', 'сек планки'),
                  _stat('${result.streakDays}', 'streak'),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onAgain,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.neon,
                    side: const BorderSide(color: AppTheme.neon),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text('Снова'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white12),
          color: Colors.black26,
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 26, color: AppTheme.neon)),
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}
