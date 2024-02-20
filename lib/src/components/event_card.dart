import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class EventCard extends StatefulWidget {
  final String title;
  final DateTime on;
  final DateTime? remind;

  const EventCard(
      {super.key, required this.title, required this.on, this.remind});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    String on = DateFormat('y MMMM d').format(widget.on);
    Duration duration = widget.on.difference(DateTime.now());
    int remainingDays = duration.inSeconds ~/ (24 * 60 * 60);
    int remainingHours = (duration.inSeconds % (24 * 60 * 60)) ~/ (60 * 60);
    int remainingMinutes = (duration.inSeconds % (60 * 60)) ~/ (60);
    int remainingSeconds = (duration.inSeconds % (60));

    String displayCountdown() {
      if (remainingDays > 0) {
        return '$remainingDays days until $on';
      }
      if (remainingHours > 0) {
        return '$remainingHours hours until $on';
      }
      if (remainingMinutes > 0) {
        return '$remainingMinutes minutes until $on';
      }
      return '$remainingSeconds seconds until $on';
    }

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && duration > const Duration(seconds: 0)) {
        setState(() {
          duration = widget.on.difference(DateTime.now());
          remainingDays = duration.inSeconds ~/ (24 * 60 * 60);
          remainingHours = (duration.inSeconds % (24 * 60 * 60)) ~/ (60 * 60);
          remainingMinutes = (duration.inSeconds % (60 * 60)) ~/ (60);
          remainingSeconds = (duration.inSeconds % 60);
        });
      }
    });
    return Card(
        child: Column(
      children: [
        ListTile(
          title: Text(widget.title),
          subtitle: Text(displayCountdown()),
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
