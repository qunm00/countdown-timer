class Event {
  int id;
  String title;
  DateTime on;
  DateTime? remind;

  Event(this.id, this.title, this.on, [this.remind]);

  isPastEvent() {
    return on.isBefore(DateTime.now());
  }

  factory Event.fromJson(Map<String, dynamic> event) {
    return Event(event['id'], event['title'], DateTime.parse(event['happenOn']),
        DateTime.tryParse(event['remind']));
  }

  Map<String, Object?> toJson() {
    return {'title': title, 'happenOn': on, 'remind': remind};
  }
}
