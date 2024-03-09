class Event {
  String title;
  DateTime on;
  DateTime? remind;

  Event(this.title, this.on, [this.remind]);

  isPastEvent() {
    return on.isBefore(DateTime.now());
  }
}
