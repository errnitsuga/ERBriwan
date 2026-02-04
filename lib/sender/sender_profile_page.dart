import 'package:flutter/material.dart';

/// Sender device profile page (existing profile).
class SenderProfilePage extends StatelessWidget {
  const SenderProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sender Profile'),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, size: 80, color: Colors.blue.shade300),
              const SizedBox(height: 24),
              Text(
                'Sender Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Device connected with existing sender profile.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
