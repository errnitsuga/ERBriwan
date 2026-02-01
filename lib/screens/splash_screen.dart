import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

/// Intro animation phases:
/// 0: White bg + small blue finger (3 sec)
/// 1: Zoom in, blue covers screen
/// 2: Logo fades in with progress bar
/// 3: Progress completes, show GET STARTED
enum _SplashPhase {
  fingerIntro,
  zoomTransition,
  logoWithProgress,
  getStarted,
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _blueBg = Color(0xFF278CBD);
  static const _orangeAccent = Color(0xFFFF9800);

  _SplashPhase _phase = _SplashPhase.fingerIntro;
  late AnimationController _zoomController;
  late AnimationController _logoController;
  late AnimationController _progressController;
  late AnimationController _getStartedController;
  Timer? _phaseTimer;

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _getStartedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _startSequence();
  }

  void _startSequence() {
    // Phase 0: Finger intro for 3 seconds
    _phaseTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _phase = _SplashPhase.zoomTransition);
      _zoomController.forward().then((_) {
        if (!mounted) return;
        setState(() => _phase = _SplashPhase.logoWithProgress);
        _logoController.forward().then((_) {
          if (!mounted) return;
          _progressController.forward().then((_) {
            if (!mounted) return;
            setState(() => _phase = _SplashPhase.getStarted);
            _getStartedController.forward();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _zoomController.dispose();
    _logoController.dispose();
    _progressController.dispose();
    _getStartedController.dispose();
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
    final bgColor = _phase == _SplashPhase.fingerIntro ||
        _phase == _SplashPhase.zoomTransition
        ? Colors.white
        : _blueBg;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      color: bgColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Phase 0: Small blue finger
          if (_phase == _SplashPhase.fingerIntro) _buildFingerIntro(),

          // Phase 1: Zoom transition
          if (_phase == _SplashPhase.zoomTransition) _buildZoomTransition(),

          // Phase 2 & 3: Logo + progress or GET STARTED
          if (_phase == _SplashPhase.logoWithProgress ||
              _phase == _SplashPhase.getStarted)
            _buildLogoAndButton(),
        ],
      ),
    );
  }

  Widget _buildFingerIntro() {
    return Center(
      child: Icon(
        Icons.touch_app,
        size: 80,
        color: _blueBg,
      ),
    );
  }

  Widget _buildZoomTransition() {
    return AnimatedBuilder(
      animation: _zoomController,
      builder: (context, child) {
        final curve = Curves.easeInOutCubic.transform(_zoomController.value);
        final scale = 1.0 + (curve * 20);
        return Center(
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: _blueBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.touch_app,
                size: 60,
                color: _blueBg,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoAndButton() {
    final showButton = _phase == _SplashPhase.getStarted;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            // Logo - higher on screen
            Expanded(
              flex: 4,
              child: FadeTransition(
                opacity: _logoController,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white.withOpacity(0.2),
                      child: const Center(
                        child: Icon(Icons.image, size: 64, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Progress bar positioned exactly below logo content (minimal 8px spacing)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: showButton
                  ? _buildGetStartedButton()
                  : _buildProgressBar(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _progressController]),
      builder: (context, child) {
        return Opacity(
          opacity: _logoController.value,
          child: SizedBox(
            key: const ValueKey('progress'),
            width: double.infinity,
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                value: _progressController.value,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGetStartedButton() {
    return FadeTransition(
      opacity: _getStartedController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _getStartedController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          key: const ValueKey('button'),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onGetStarted,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _orangeAccent,
                      Color.lerp(_orangeAccent, Colors.deepOrange, 0.2)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _orangeAccent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'GET STARTED',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}