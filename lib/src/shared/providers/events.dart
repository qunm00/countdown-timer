import 'package:countdown_timer/src/shared/classes/event.dart';
import 'package:flutter/material.dart';

class EventsModel extends ChangeNotifier {
  // TODO sorted by on
  List<Event> events = [
    Event("Valentine's Day", DateTime(2024, 02, 14)),
    Event('Halloween', DateTime(2024, 10, 31)),
    Event('Tomorrow', DateTime.now().add(const Duration(days: 1))),
    Event(
        '10 minutes from now', DateTime.now().add(const Duration(minutes: 10))),
    Event(
        '10 seconds from now', DateTime.now().add(const Duration(seconds: 10)))
  ];

  List<Event> get upcomingEvents =>
      events.where((element) => element.on.isAfter(DateTime.now())).toList();
  List<Event> get pastEvents =>
      events.where((element) => element.on.isBefore(DateTime.now())).toList();

  removeEvent(Event event) {
    events.remove(event);
    notifyListeners();
  }

  addEvent(Event event) {
    debugPrint('addEvent');
    print('event $event');
    events.add(event);
    notifyListeners();
  }
}
