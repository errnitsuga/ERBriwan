import 'package:flutter/material.dart';

import '../data/mock_connection_service.dart';
import '../receiver/receiver_registration_page.dart';
import '../sender/sender_registration_page.dart';
import '../receiver/receiver_dashboard_page.dart';
import '../sender/sender_dashboard_page.dart';
import 'wifi_selection_page.dart';

/// Home page - Welcome to ERBriwan with device overlay
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _blueHeader = Color(0xFF2D92D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with clear color division
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

          // Content with proper overlay positioning
          SafeArea(
            child: Column(
              children: [
                // Top blue section - 50% of screen
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Centered device image
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/images/erb-front.png',
                            height: 400,
                            width: 400,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => _buildFallbackDevice(),
                          ),
                        ),
                      ),

                      // Welcome text overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 32),
                              Text(
                                'Welcome',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'to',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ER',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
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
                                    'Briwan',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Emergency Response Button for Everyone',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom section with text and buttons
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Safety, Simplified.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'One press to alert help.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Designed wherever you go.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        _ActionButton(
                          icon: Icons.add,
                          label: 'Connect Device',
                          isPrimary: true,
                          onTap: () => _showConnectionPopup(context),
                        ),
                        const SizedBox(height: 16),
                        _ActionButton(
                          icon: Icons.accessibility_new,
                          label: 'View Instructions',
                          isPrimary: false,
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackDevice() {
    return Container(
      width: 400,
      height: 400,
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

  static void _showConnectionPopup(BuildContext context) {
    bool deviceHasInternet = true;
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Connection result (mock)'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Choose a scenario to simulate device connection:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: deviceHasInternet,
                      onChanged: (v) =>
                          setState(() => deviceHasInternet = v ?? true),
                      title: const Text('Device has internet'),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 8),
                    _ScenarioButton(
                      label: 'Sender device connected with existing profile',
                      onTap: () => _onScenarioSelected(
                        context,
                        ConnectionScenario.senderWithProfile,
                        deviceHasInternet,
                      ),
                    ),
                    _ScenarioButton(
                      label: 'Receiver device connected with existing profile',
                      onTap: () => _onScenarioSelected(
                        context,
                        ConnectionScenario.receiverWithProfile,
                        deviceHasInternet,
                      ),
                    ),
                    _ScenarioButton(
                      label: 'Sender device connected without existing profile',
                      onTap: () => _onScenarioSelected(
                        context,
                        ConnectionScenario.senderWithoutProfile,
                        deviceHasInternet,
                      ),
                    ),
                    _ScenarioButton(
                      label: 'Receiver device connected without existing profile',
                      onTap: () => _onScenarioSelected(
                        context,
                        ConnectionScenario.receiverWithoutProfile,
                        deviceHasInternet,
                      ),
                    ),
                    _ScenarioButton(
                      label: 'No device detected – try again',
                      onTap: () => _onScenarioSelected(
                        context,
                        ConnectionScenario.noDevice,
                        deviceHasInternet,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void _onScenarioSelected(
    BuildContext context,
    ConnectionScenario scenario,
    bool hasInternet,
  ) {
    Navigator.of(context).pop(); // close dialog
    if (scenario == ConnectionScenario.noDevice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(scenario.message)),
      );
      return;
    }
    // Show notification message then navigate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(scenario.message),
        duration: const Duration(seconds: 2),
      ),
    );
    final Widget targetPage;
    switch (scenario) {
      case ConnectionScenario.senderWithProfile:
        targetPage = const SenderDashboardPage(initialIndex: 0);
        break;
      case ConnectionScenario.receiverWithProfile:
        targetPage = const ReceiverDashboardPage(initialIndex: 0);
        break;
      case ConnectionScenario.senderWithoutProfile:
        targetPage = const SenderRegistrationPage();
        break;
      case ConnectionScenario.receiverWithoutProfile:
        targetPage = const ReceiverRegistrationPage();
        break;
      case ConnectionScenario.noDevice:
        return;
    }
    if (hasInternet) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => targetPage),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WifiSelectionPage(targetPage: targetPage),
        ),
      );
    }
  }

  Widget _buildBackground(BuildContext context) {
    return Column(
      children: [
        // Blue header (50%)
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _blueHeader,
            ),
          ),
        ),
        // Blurred cityscape (50%)
        Expanded(
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

class _ScenarioButton extends StatelessWidget {
  const _ScenarioButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextButton(
        onPressed: onTap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
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
                  fontSize: 18,
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

