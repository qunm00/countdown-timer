import 'dart:async';

import 'package:countdown_timer/src/views/edit_event.dart';
import 'package:countdown_timer/src/views/events_list.dart';
import 'package:countdown_timer/src/shared/classes/event.dart';
import 'package:flutter/material.dart';
import 'src/shared/providers/events.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EventsModel(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(
            title: 'Events',
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<EventsModel>();
    var upcomingEvents = appState.upcomingEvents;
    var pastEvents = appState.pastEvents;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // TODO optimize so that the list only update when there is past event
        // * does not need to periodically check
        setState(() {
          upcomingEvents = appState.upcomingEvents;
          pastEvents = appState.pastEvents;
        });
      }
    });
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: const TabBar(tabs: [
                Tab(text: 'Upcoming Events'),
                Tab(text: 'Past Events')
              ]),
              title: Text(widget.title)),
          body: TabBarView(children: [
            EventsList(events: upcomingEvents),
            EventsList(events: pastEvents),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EditEvent()));
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
