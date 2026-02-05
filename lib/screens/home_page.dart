import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../receiver/receiver_registration_page.dart';
import '../sender/sender_registration_page.dart';
import '../receiver/receiver_dashboard_page.dart';
import '../sender/sender_dashboard_page.dart';
import 'wifi_selection_page.dart';

/// Home page - Welcome to ERBriwan with device overlay
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _blueHeader = Color(0xFF2D92D2);
  static const _deviceBaseUrl = 'http://192.168.4.1:80';

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

          // Top-left overlay: mockup menu to jump to sender/receiver
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => _showMockNavigationPopup(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.menu, color: Color(0xFF2D92D2)),
                    ),
                  ),
                ),
              ),
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
                          onTap: () => _handleConnectDevice(context),
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

  static Future<void> _handleConnectDevice(BuildContext context) async {
    // Simple loading dialog while talking to ESP32.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    bool? isSender;
    try {
      final typeRes = await http
          .get(Uri.parse('$_deviceBaseUrl/type'))
          .timeout(const Duration(seconds: 5));

      if (typeRes.statusCode == 200) {
        final body = typeRes.body.trim();
        if (body.isNotEmpty) {
          final data = jsonDecode(body) as Map<String, dynamic>;
          // Device may return "sender": true/1 or "isSender": true/1
          final raw = data['sender'] ?? data['isSender'];
          if (raw != null) {
            if (raw == true || raw == 1) {
              isSender = true;
            } else if (raw == false || raw == 0) {
              isSender = false;
            } else if (raw is String) {
              final s = raw.toLowerCase();
              if (s == 'true' || s == '1') isSender = true;
              else if (s == 'false' || s == '0') isSender = false;
            }
          }
        }
      }
    } catch (_) {
      // fall-through to no-device popup
    } finally {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // close loader
      }
    }

    if (isSender == null) {
      await _showNoDeviceDialog(context);
      return;
    }

    final confirmed = await _showDeviceDetectedDialog(context, isSender);
    if (confirmed != true) return;

    // After confirm, check profile.
    await _handleProfileFlow(context, isSender);
  }

  static Future<void> _handleProfileFlow(
    BuildContext context,
    bool isSender,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    Map<String, dynamic>? profile;
    try {
      final res = await http
          .get(Uri.parse('$_deviceBaseUrl/getProfile'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200 && res.body.trim().isNotEmpty) {
        profile = jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (_) {
      // treat as no profile from device
    } finally {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // close loader
      }
    }

    // Consider profile existing if we got any non-empty string field (fullname, address, etc.)
    bool hasProfile = false;
    if (profile != null) {
      for (final v in profile.values) {
        if (v is String && v.trim().isNotEmpty) {
          hasProfile = true;
          break;
        }
      }
    }
    // Mock profile: when getProfile fails or returns empty, still go to WiFi selection for testing
    const useMockProfile = true;
    if (!hasProfile && useMockProfile) {
      hasProfile = true;
    }

    if (!hasProfile) {
      await _showNoProfileDialog(context, isSender);
      return;
    }

    // Existing profile (or mock) -> go to WiFi selection page.
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const WifiSelectionPage(),
      ),
    );
  }

  static void _showMockNavigationPopup(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Mock: Go to',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.send_rounded),
              title: const Text('Sender profile'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SenderDashboardPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android_rounded),
              title: const Text('Receiver profile'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ReceiverDashboardPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Future<void> _showNoDeviceDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phonelink_off,
                  size: 48, color: Color(0xFF2D92D2)),
              const SizedBox(height: 16),
              const Text(
                'No Device Connected',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Make sure your phone is connected to the ERBriwan network before trying again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool?> _showDeviceDetectedDialog(
    BuildContext context,
    bool isSender,
  ) {
    final titleText =
        isSender ? 'Sender Device Detected' : 'Receiver Device Detected';
    final subtitleText = isSender
        ? 'Please confirm to proceed.'
        : 'Please confirm to proceed.';

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D92D2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smartphone,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2D92D2),
                          side: const BorderSide(color: Color(0xFF2D92D2)),
                          minimumSize: const Size(110, 40),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2D92D2),
                          minimumSize: const Size(110, 40),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> _showNoProfileDialog(
    BuildContext context,
    bool isSender,
  ) {
    final title = isSender
        ? 'No existing sender profile found'
        : 'No existing receiver profile found';
    final buttonLabel = isSender ? 'Register Sender' : 'Register Receiver';
    final description = isSender
        ? 'Please register by creating a new sender profile to proceed.'
        : 'Please register by creating a new receiver profile to proceed.';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2D92D2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => isSender
                                ? const SenderRegistrationPage()
                                : const ReceiverRegistrationPage(),
                          ),
                        );
                      },
                      child: Text(buttonLabel),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'If you have an existing profile, go to the profile page to edit.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

