class Event {
  String title;
  DateTime on;
  DateTime? remind;

  Event(this.title, this.on);

  isPastEvent() {
    return on.isBefore(DateTime.now());
  }
}
