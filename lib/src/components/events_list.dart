import 'package:countdown_timer/src/components/event_card.dart';
import 'package:flutter/material.dart';
import 'package:countdown_timer/src/shared/classes/event.dart';

// TODO update this list when events change
class EventsList extends StatefulWidget {
  final List<Event> events;

  const EventsList({super.key, required this.events});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (context, index) {
        Event event = widget.events[index];
        return EventCard(
            title: event.title, on: event.on, remind: event.remind);
      },
    );
  }
}
