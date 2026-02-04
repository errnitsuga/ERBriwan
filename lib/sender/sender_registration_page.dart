import 'package:flutter/material.dart';

import 'sender_dashboard_page.dart';

/// Sender device registration page (no existing profile).
class SenderRegistrationPage extends StatelessWidget {
  const SenderRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sender Registration'),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add_rounded, size: 80, color: Colors.blue.shade300),
              const SizedBox(height: 24),
              Text(
                'Sender Registration',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Register this sender device. No existing profile found.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SenderDashboardPage()),
                  );
                },
                child: const Text('Finish registration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
