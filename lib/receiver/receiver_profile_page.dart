import 'package:flutter/material.dart';

/// Receiver device profile page (existing profile).
class ReceiverProfilePage extends StatelessWidget {
  const ReceiverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receiver Profile'),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android_rounded, size: 80, color: Colors.green.shade300),
              const SizedBox(height: 24),
              Text(
                'Receiver Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Device connected with existing receiver profile.',
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
