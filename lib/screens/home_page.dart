import 'package:flutter/material.dart';

/// Home page - Welcome to ERBriwan with device overlay
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _blueHeader = Color(0xFF2D92D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          // Semi-transparent location pin overlay
          Positioned(
            right: -40,
            bottom: 100,
            child: Icon(
              Icons.location_on,
              size: 200,
              color: Colors.pink.withOpacity(0.25),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Top section: device image + Welcome text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Device image overlay
                      Image.asset(
                        'assets/images/erb-front.png',
                        height: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _buildFallbackDevice(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'to',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ER',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.orange, width: 2),
                                  ),
                                  child: Icon(Icons.touch_app, size: 16, color: Colors.white),
                                ),
                                Text(
                                  'biwan',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Emergency Response Button for Everyone',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Safety, Simplified.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'One press to alert help.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                  Text(
                    'Designed wherever you go.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                  const Spacer(),
                  _ActionButton(
                    icon: Icons.add,
                    label: 'Connect Device',
                    isPrimary: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.accessibility_new,
                    label: 'View Instructions',
                    isPrimary: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackDevice() {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF42A5F5),
            Color(0xFF1976D2),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.emergency, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Column(
      children: [
        // Blue header (~42%)
        Expanded(
          flex: 42,
          child: Container(
            decoration: BoxDecoration(
              color: _blueHeader,
            ),
          ),
        ),
        // Blurred cityscape (~58%)
        Expanded(
          flex: 58,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder for cityscape - gradient simulating bokeh
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1a5a8a),
                      const Color(0xFF0d3d66),
                    ],
                  ),
                ),
              ),
              // Bokeh-style city lights
              ...List.generate(40, (i) {
                return Positioned(
                  left: (i * 31.0) % (MediaQuery.of(context).size.width + 50) - 10,
                  bottom: (i * 19.0) % 200,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.4 + (i % 3) * 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
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
    const blue = Color(0xFF2D92D2);
    return Material(
      color: isPrimary ? blue : Colors.white,
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
              color: isPrimary ? Colors.white : blue,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : blue,
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
