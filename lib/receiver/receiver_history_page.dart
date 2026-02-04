import 'package:flutter/material.dart';

class ReceiverHistoryPage extends StatelessWidget {
  const ReceiverHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _HistoryTile(title: 'Alert received', subtitle: 'Today • 10:02 AM'),
        _HistoryTile(title: 'Alert received', subtitle: 'Yesterday • 9:14 PM'),
        _HistoryTile(title: 'Device paired', subtitle: 'Jan 12 • 3:40 PM'),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event_note),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

