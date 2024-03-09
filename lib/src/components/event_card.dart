import 'package:countdown_timer/src/shared/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../shared/classes/event.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    Event event = widget.event;
    String on = DateFormat('y MMMM d').format(event.on);
    Duration duration = event.on.difference(DateTime.now());
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
      // TODO buggy when seconds is 0, then switch tab
      // TODO past events are unhandled
      // TODO current events become past events should automatilly be moved to past events
      if (mounted && duration > const Duration(seconds: 0)) {
        setState(() {
          duration = event.on.difference(DateTime.now());
          remainingDays = duration.inSeconds ~/ (24 * 60 * 60);
          remainingHours = (duration.inSeconds % (24 * 60 * 60)) ~/ (60 * 60);
          remainingMinutes = (duration.inSeconds % (60 * 60)) ~/ (60);
          remainingSeconds = (duration.inSeconds % 60);
        });
      }
    });

    var appState = Provider.of<EventsModel>(context);

    return Card(
        child: Column(
      children: [
        ListTile(
          title: Text(event.title),
          subtitle: Text(displayCountdown()),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
              // TODO what happens when edit?
              onPressed: () => (debugPrint('edit')),
              child: const Text('Edit')),
          TextButton(
            onPressed: () => appState.removeEvent(event),
            child: const Text('Delete'),
          )
        ])
      ],
    ));
  }
}
