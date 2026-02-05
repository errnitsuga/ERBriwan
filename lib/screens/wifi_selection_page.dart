import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../receiver/receiver_dashboard_page.dart';
import '../sender/sender_dashboard_page.dart';

/// WiFi selection page - shows networks detected by the device.
class WifiSelectionPage extends StatefulWidget {
  const WifiSelectionPage({super.key, this.targetPage});

  /// Page to navigate to after user selects a WiFi (mock: tap any network).
  final Widget? targetPage;

  @override
  State<WifiSelectionPage> createState() => _WifiSelectionPageState();
}

class _WifiSelectionPageState extends State<WifiSelectionPage> {
  static const _deviceBaseUrl = 'http://192.168.4.1:80';

  List<_NetworkInfo> _networks = const [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('$_deviceBaseUrl/detectNetworks');
      final res = await http.get(uri).timeout(
        const Duration(seconds: 12),
        onTimeout: () => throw Exception(
          'Request timed out. Ensure your phone is connected to the ERBriwan WiFi.',
        ),
      );

      if (res.statusCode != 200) {
        setState(() {
          _error =
              'Device returned ${res.statusCode}. Ensure phone is on ERBriwan WiFi.';
          _loading = false;
        });
        return;
      }

      final body = res.body.trim();
      if (body.isEmpty) {
        setState(() {
          _error = 'Device returned empty response.';
          _loading = false;
        });
        return;
      }

      final json = jsonDecode(body) as Map<String, dynamic>;
      // Accept "networks" or "Networks", "isSecure" or "isSecure"
      final List<dynamic> ssids = (json['networks'] ?? json['Networks'])
          as List<dynamic>? ?? [];
      final List<dynamic> secureFlags =
          (json['isSecure'] ?? json['IsSecure']) as List<dynamic>? ?? [];

      final List<_NetworkInfo> parsed = [];
      for (var i = 0; i < ssids.length; i++) {
        final ssid = (ssids[i] ?? '').toString();
        final isSecure = i < secureFlags.length
            ? (secureFlags[i] == true || secureFlags[i] == 1)
            : false;
        final strength = (3 - (i ~/ 2)).clamp(1, 3);
        parsed.add(
          _NetworkInfo(
            ssid: ssid,
            isSecure: isSecure,
            strength: strength,
          ),
        );
      }

      setState(() {
        _networks = parsed;
        _loading = false;
      });
    } on Exception catch (e) {
      final msg = e.toString();
      final isTimeout = msg.contains('TimeoutException') ||
          msg.contains('timed out') ||
          msg.contains('future not completed');
      setState(() {
        _error = isTimeout
            ? 'Request timed out. Make sure your phone is connected to the ERBriwan WiFi (device hotspot), then pull down to retry.'
            : 'Failed to contact device: $msg';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to contact device: $e';
        _loading = false;
      });
    }
  }

  void _onNetworkTap(_NetworkInfo network) {
    showDialog<void>(
      context: context,
      builder: (_) {
        final controller = TextEditingController();
        final secure = network.isSecure;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(network.ssid),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _WifiStrengthIcon(strength: network.strength),
                  const SizedBox(width: 8),
                  if (secure)
                    const Icon(Icons.lock, size: 18, color: Colors.black54)
                  else
                    const Text(
                      'Open network',
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (secure)
                TextField(
                  controller: controller,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                )
              else
                const Text(
                  'No password required for this network.',
                  style: TextStyle(fontSize: 13),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      secure
                          ? 'Captured password for ${network.ssid} (mock only).'
                          : 'Selected open network ${network.ssid} (mock only).',
                    ),
                  ),
                );
                final next = widget.targetPage;
                if (next != null && mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => next),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Selection'),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (_) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Sender dashboard'),
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
                        leading: const Icon(Icons.phone_android),
                        title: const Text('Receiver dashboard'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReceiverDashboardPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: _loading ? null : _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.wifi_find_rounded,
                    size: 28, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Nearby WiFi networks (including hotspots)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Networks detected by ERBriwan device. Tap a WiFi to view details and enter password.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )


            else
              ..._networks.map((net) {
                final title =
                    net.ssid.trim().isEmpty ? '<Hidden SSID>' : net.ssid;
                return Card(
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _WifiStrengthIcon(strength: net.strength),
                        if (net.isSecure)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(Icons.lock, size: 16),
                          ),
                      ],
                    ),
                    title: Text(title),
                    subtitle: Text(
                      net.isSecure ? 'Secure network' : 'Open network',
                    ),
                    onTap: () => _onNetworkTap(net),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _NetworkInfo {
  _NetworkInfo({
    required this.ssid,
    required this.isSecure,
    required this.strength,
  });

  final String ssid;
  final bool isSecure;
  final int strength; // 1–3 bars
}

class _WifiStrengthIcon extends StatelessWidget {
  const _WifiStrengthIcon({required this.strength});

  final int strength;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (strength.clamp(1, 3)) {
      case 1:
        icon = Icons.network_wifi_1_bar;
        break;
      case 2:
        icon = Icons.network_wifi_2_bar;
        break;
      default:
        icon = Icons.network_wifi_3_bar;
    }
    return Icon(icon);
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.message,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final String message;
  final Future<bool> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WiFi scan unavailable',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
                OutlinedButton(
                  onPressed: () => onOpenSettings(),
                  child: const Text('Open settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
