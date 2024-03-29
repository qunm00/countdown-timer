import 'package:countdown_timer/src/classes/event.dart';
import 'package:countdown_timer/src/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({super.key, this.id});
  final int? id;

  @override
  State<EditEvent> createState() {
    return _EditEventState();
  }
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _remindOnController = TextEditingController();
  final TextEditingController _title = TextEditingController();

  Future<bool> populatedFields() async {
    if (widget.id != null) {
      Event event = await EventsModel.getEvent(widget.id!);
      _title.text = event.title;
      _dateController.text = DateFormat.yMMMd().format(event.on);
      _remindOnController.text =
          event.remind != null ? DateFormat.yMMMd().format(event.remind!) : '';
      return true;
    }
    return true;
  }

  Future<void> _showDatePicker(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );

    if (pickedDate != null) {
      // get only the date part, omit the time part
      _dateController.text = DateFormat.yMMMd().format(pickedDate);
    }
  }

  Future<void> _showRemindOnPicker(context) async {
    DateTime? pickedRemindOn = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );

    if (pickedRemindOn != null) {
      // get only the date part, omit the time part
      _remindOnController.text = DateFormat.yMMMd().format(pickedRemindOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<EventsModel>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: widget.id != null
              ? const Text('Edit event')
              : const Text('Add event'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: FutureBuilder(
            future: populatedFields(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Title'),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please give an event title';
                              }
                              return null;
                            },
                            controller: _title,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: TextFormField(
                              showCursor: false,
                              readOnly: true,
                              validator: (value) {
                                if (value == null) {
                                  return 'A date is required';
                                }

                                DateTime? parsedDateTime =
                                    DateFormat.yMMMd().tryParse(value);
                                if (parsedDateTime == null) {
                                  return 'Please enter a valid date';
                                }
                                if (_remindOnController.text.isNotEmpty &&
                                    parsedDateTime.compareTo(DateFormat.yMMMd()
                                            .parse(_remindOnController.text)) <
                                        0) {
                                  return 'Event should be happening before reminder date';
                                }
                                if (parsedDateTime.compareTo(DateTime.now()) <
                                    0) {
                                  return 'Event should be happening in the future';
                                }
                                return null;
                              },
                              controller: _dateController,
                              onTap: () {
                                _showDatePicker(context);
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Choose a date'),
                                  prefixIcon: Icon(Icons.calendar_today)),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }
                                DateTime? parsedDateTime =
                                    DateFormat.yMMMd().tryParse(value);
                                if (parsedDateTime == null) {
                                  return 'Please enter a valid date';
                                }
                                if (_dateController.text.isNotEmpty &&
                                    parsedDateTime.compareTo(DateFormat.yMMMd()
                                            .parse(_dateController.text)) >
                                        0) {
                                  return 'Please choose a date that is earlier than when this event happens';
                                }
                                if (parsedDateTime.compareTo(DateTime.now()) <
                                    0) {
                                  return 'Please choose a date in the future';
                                }
                                return null;
                              },
                              showCursor: false,
                              readOnly: true,
                              controller: _remindOnController,
                              onTap: () {
                                _showRemindOnPicker(context);
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Remind on'),
                                  prefixIcon:
                                      Icon(Icons.watch_later_outlined))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.reset();
                                },
                                child: const Text('Reset')),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, dynamic> event = {
                                        'title': _title.text,
                                        'on': DateFormat.yMMMd()
                                            .parse(_dateController.text),
                                        'remind': DateFormat.yMMMd()
                                            .parse(_remindOnController.text),
                                      };
                                      if (widget.id == null) {
                                        await appState.addEvent(event);
                                      } else {
                                        await appState.updateEvent(
                                            widget.id, event);
                                      }

                                      Navigator.pop(context);
                                    }
                                  } catch (error) {
                                    const snackBar = SnackBar(
                                        content:
                                            Text('Unable to save the event'));
                                    debugPrint('$error');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: const Text('Submit'))
                          ],
                        )
                      ],
                    ));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
