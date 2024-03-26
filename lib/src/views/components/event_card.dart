import 'package:countdown_timer/src/providers/events.dart';
import 'package:countdown_timer/src/views/edit_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../../classes/event.dart';

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
    String on = DateFormat('yMMMd').format(event.on);
    Duration duration = event.on.difference(DateTime.now());

    String displayCountdown() {
      int absoluteDuration = duration.inSeconds.abs();
      int remainingDays = absoluteDuration ~/ (24 * 60 * 60);
      int remainingHours = (absoluteDuration % (24 * 60 * 60)) ~/ (60 * 60);
      int remainingMinutes = (absoluteDuration % (60 * 60)) ~/ (60);
      int remainingSeconds = (absoluteDuration % 60);
      String prefix = duration > Duration.zero ? 'until' : 'ago on';
      if (remainingDays > 0) {
        return '$remainingDays day(s) $prefix $on';
      }
      if (remainingHours > 0) {
        return '$remainingHours hour(s) $prefix $on';
      }
      if (remainingMinutes > 0) {
        return '$remainingMinutes minute(s) $prefix $on';
      }
      return '$remainingSeconds second(s) $prefix $on';
    }

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && duration > const Duration(seconds: 0)) {
        setState(() {
          duration = event.on.difference(DateTime.now());
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
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditEvent(id: event.id))),
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
