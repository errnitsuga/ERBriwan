import 'package:flutter/material.dart';

import 'sender_history_page.dart';
import 'sender_profile_tab.dart';

class SenderDashboardPage extends StatefulWidget {
  const SenderDashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<SenderDashboardPage> createState() => _SenderDashboardPageState();
}

class _SenderDashboardPageState extends State<SenderDashboardPage> {
  late int _index = widget.initialIndex.clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final pages = const [
      SenderProfileTab(),
      SenderHistoryPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(['Profile', 'History'][_index]),
        backgroundColor: const Color(0xFF2D92D2),
        foregroundColor: Colors.white,
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}

