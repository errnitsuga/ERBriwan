import 'package:flutter/material.dart';

import 'receiver_history_page.dart';
import 'receiver_map_page.dart';
import 'receiver_profile_tab.dart';

class ReceiverDashboardPage extends StatefulWidget {
  const ReceiverDashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ReceiverDashboardPage> createState() => _ReceiverDashboardPageState();
}

class _ReceiverDashboardPageState extends State<ReceiverDashboardPage> {
  late int _index = widget.initialIndex.clamp(0, 2);

  @override
  Widget build(BuildContext context) {
    final pages = const [
      ReceiverProfileTab(),
      ReceiverMapPage(),
      ReceiverHistoryPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(['Profile', 'Map', 'History'][_index]),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}

