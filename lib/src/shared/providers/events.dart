import 'package:countdown_timer/src/shared/classes/event.dart';
import 'package:countdown_timer/src/shared/utils/event_sql.dart';
import 'package:flutter/material.dart';

class EventsModel extends ChangeNotifier {
  List<Event> events = [];

  List<Event> get upcomingEvents =>
      events.where((element) => element.on.isAfter(DateTime.now())).toList();
  List<Event> get pastEvents =>
      events.where((element) => element.on.isBefore(DateTime.now())).toList();

  Future<void> getEvents() async {
    List<Map<String, dynamic>> result = await EventSQLite.getItems();
    events = List.generate(result.length, (index) {
      Map<String, Object?> event = result[index];
      return Event.fromJson(event);
    });
  }

  Future<Event> getEvent(id) async {
    List<Map<String, dynamic>> result = await EventSQLite.getItem(id);
    if (result.isEmpty) throw 'Event is not found';
    return Event.fromJson(result[0]);
  }

  Future<int> updateEvent(id, {title, on, remind}) async {
    int updatedItem = await EventSQLite.updateItem(id, title, on, remind);
    return updatedItem;
  }

  Future<void> removeEvent(Event event) async {
    await EventSQLite.deleteItem(event.id);
  }

  Future<void> addEvent(Map<String, dynamic> event) async {
    await EventSQLite.createItem(event['title'], event['on'], event['remind']);
    await getEvents();
    notifyListeners();
  }
}
