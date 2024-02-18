import 'package:countdown_timer/src/components/event_card.dart';
import 'package:flutter/material.dart';
import 'package:countdown_timer/src/shared/classes/event.dart';

// class EventsList extends StatelessWidget {
//   const EventsList({super.key, required List<Event> events});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: const [EventCard()],
//     );
//   }
// }

class EventsList extends StatefulWidget {
  EventsList({super.key, required List<Event> events});

  // TODO receive a list of events from parent (main.dart)

  @override
  State<EventsList> createState() => _EventsState();
}

class _EventsState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    // TODO loop over the list of events
    return ListView(
      children: const [EventCard()],
    );
  }
}
