import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_page.dart';

/// Animated splash/opening screen for ERBriwan app
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blueBg = Color(0xFF2196F3);
    const orangeAccent = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: blueBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Central brand icon with hand + emergency bell
              _BrandIcon(pulseController: _pulseController)
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 24),
              // App name
              Text(
                'ERBriwan',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 8),
              // Tagline
              Text(
                'Emergency Response Button for Everyone',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w400,
                    ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 32),
              // Feature icons row
              _FeatureIconsRow()
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              const Spacer(flex: 3),
              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeAccent,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: orangeAccent.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'GET STARTED',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms)
                  .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Brand icon: hand pressing emergency bell with orange ring
class _BrandIcon extends StatelessWidget {
  final AnimationController pulseController;

  const _BrandIcon({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glow = 1.0 + (pulseController.value * 0.08);
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF9800),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9800).withOpacity(0.4),
                blurRadius: 20 * glow,
                spreadRadius: 2 * glow,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Emergency bell/siren icon at top
              Positioned(
                top: 18,
                child: Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              // Hand tap icon
              Icon(
                Icons.touch_app,
                color: Colors.white,
                size: 48,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Feature icons: location, smartphone alert, ambulance
class _FeatureIconsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on_outlined, color: Colors.white, size: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              Icon(Icons.smartphone, color: Colors.white, size: 28),
              Icon(Icons.error_outline, color: Colors.white, size: 16),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.local_hospital_outlined, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
