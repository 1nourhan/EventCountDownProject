import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_new_project/bloc/event_cubit.dart';
import 'package:new_new_project/screens/event_list_page.dart';
import 'package:new_new_project/services/event_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventCubit(EventDatabase.instance)..loadEvents(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Countdown App',
        home: EventListPage(),
      ),
    );
  }
}
