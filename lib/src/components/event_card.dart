import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        const ListTile(
          title: Text("Mother's Day"),
          subtitle: Text("Sometimes"),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
              // TODO what happens when edit?
              onPressed: () => (debugPrint('edit')),
              child: const Text('Edit')),
          TextButton(
            // TODO what happens when delete?
            onPressed: () => debugPrint('delete'),
            child: const Text('Delete'),
          )
        ])
      ],
    ));
  }
}
