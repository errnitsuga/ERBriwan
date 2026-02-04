import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// WiFi selection page when device is not connected to internet.
class WifiSelectionPage extends StatefulWidget {
  const WifiSelectionPage({super.key, this.targetPage});

  /// Page to navigate to after user selects a WiFi (mock: tap any network).
  final Widget? targetPage;

  @override
  State<WifiSelectionPage> createState() => _WifiSelectionPageState();
}

class _WifiSelectionPageState extends State<WifiSelectionPage> {
  List<WiFiAccessPoint> _accessPoints = const [];
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
      // Location permission is required to scan WiFi SSIDs on Android.
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        setState(() {
          _error =
              'Location permission is required to scan nearby WiFi networks.';
          _loading = false;
        });
        return;
      }

      final can = await WiFiScan.instance.canStartScan();
      if (can != CanStartScan.yes) {
        setState(() {
          _error =
              'Cannot start WiFi scan: ${can.name}. Turn on WiFi and Location services.';
          _loading = false;
        });
        return;
      }

      await WiFiScan.instance.startScan();

      final canGet = await WiFiScan.instance.canGetScannedResults();
      if (canGet != CanGetScannedResults.yes) {
        setState(() {
          _error =
              'Cannot read WiFi scan results: ${canGet.name}.';
          _loading = false;
        });
        return;
      }

      final results = await WiFiScan.instance.getScannedResults();
      results.sort((a, b) => b.level.compareTo(a.level));

      setState(() {
        _accessPoints = results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to scan WiFi networks: $e';
        _loading = false;
      });
    }
  }

  void _selectNetwork(WiFiAccessPoint ap) {
    final navigator = Navigator.of(context);
    final next = widget.targetPage;
    navigator.pop();
    if (next != null) {
      navigator.push(MaterialPageRoute(builder: (_) => next));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Selection'),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
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
              'Pull down to rescan. If you don’t see your hotspot, make sure WiFi + Location are ON.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _ErrorCard(
                message: _error!,
                onOpenSettings: openAppSettings,
                onRetry: _refresh,
              )
            else if (_accessPoints.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No networks found.')),
              )
            else
              ..._accessPoints.map((ap) {
                final ssid = ap.ssid.trim();
                final title = ssid.isEmpty ? '<Hidden SSID>' : ssid;
                final level = ap.level;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.wifi),
                    title: Text(title),
                    subtitle: Text(
                      [
                        if (ap.capabilities.trim().isNotEmpty)
                          ap.capabilities,
                        'Signal: $level dBm',
                      ].join(' • '),
                    ),
                    onTap: () => _selectNetwork(ap),
                  ),
                );
              }),
          ],
        ),
      ),
    );
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
