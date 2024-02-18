import 'package:countdown_timer/src/shared/classes/event.dart';

class Events {
  List<Event> events = [
    Event("Valentine's Day", DateTime(2024, 02, 14)),
    Event('Halloween', DateTime(2024, 10, 31)),
  ];

  List<Event> get currentEvents =>
      events.where((element) => element.on.isAfter(DateTime.now())).toList();
  List<Event> get pastEvents =>
      events.where((element) => element.on.isBefore(DateTime.now())).toList();
}
