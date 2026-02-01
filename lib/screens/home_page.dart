import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Home page shown after Get Started - Welcome to ERBriwan
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background: blue gradient + blurred city
          _buildBackground(context),
          // Large map pin decoration
          Positioned(
            right: -60,
            bottom: 80,
            child: Icon(
              Icons.location_on,
              size: 180,
              color: Colors.purple.withOpacity(0.15),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Welcome text
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        const TextSpan(text: 'Welcome '),
                        TextSpan(
                          text: 'to',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const TextSpan(text: '\nERBriwan'),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 8),
                  Text(
                    'Emergency Response Button for Everyone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 500.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 12),
                  Text(
                    'Safety, Simplified.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w600,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 500.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  Text(
                    'One press to alert help. Designed wherever you go.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.75),
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 500.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 32),
                  // Device illustration
                  _DeviceIllustration()
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideX(begin: -0.3, end: 0, curve: Curves.easeOutBack),
                  const Spacer(),
                  // Action buttons
                  _ActionButton(
                    icon: Icons.add,
                    label: 'Connect Device',
                    isPrimary: true,
                    onTap: () {
                      // TODO: Navigate to device connection
                    },
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.directions_walk,
                    label: 'View Instructions',
                    isPrimary: false,
                    onTap: () {
                      // TODO: Navigate to instructions
                    },
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 500.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Column(
      children: [
        // Blue gradient top
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1976D2),
                  const Color(0xFF2196F3),
                  const Color(0xFF42A5F5),
                ],
              ),
            ),
          ),
        ),
        // Blurred city / darker bottom
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1565C0),
                  const Color(0xFF0D47A1),
                ],
              ),
            ),
            child: Stack(
              children: [
                // City lights effect - subtle dots
                ...List.generate(30, (i) {
                  return Positioned(
                    left: (i * 37.0) % 400 - 20,
                    bottom: (i * 23.0) % 120,
                    child: Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Capsule-shaped device with red emergency button
class _DeviceIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1976D2),
            Color(0xFF0D47A1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Antenna
          Positioned(
            top: -20,
            left: 80,
            child: Container(
              width: 3,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Red emergency button
          Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade600,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          // ERBriwan label
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Text(
              'ERBriwan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const lightBlue = Color(0xFF64B5F6);
    return Material(
      color: isPrimary ? lightBlue : Colors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isPrimary ? Colors.white : lightBlue,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : lightBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : lightBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
