import 'package:countdown_timer/src/components/events_list.dart';
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<EventsModel>();
    var upcomingEvents = appState.upcomingEvents;
    var pastEvents = appState.pastEvents;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: const TabBar(tabs: [
                Tab(text: 'Upcoming Events'),
                Tab(text: 'Past Events')
              ]),
              title: Text(title)),
          body: TabBarView(children: [
            EventsList(events: upcomingEvents),
            EventsList(events: pastEvents),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Pressed'),
              ));
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
