import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_new_project/bloc/event_cubit.dart';
import 'package:new_new_project/screens/event_page.dart';

import '../bloc/event_state.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event List')),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            if (state.events.isEmpty) {
              return Center(child: Text('No events yet.'));
            }
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                final timeRemaining = event.date.difference(DateTime.now());

                return ListTile(
                  leading: event.imagePath.isNotEmpty
                      ? Image.file(
                    File(event.imagePath),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/default_event_image.png', // Default image from assets
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(event.title),
                  subtitle: Text('${timeRemaining.inDays} days remaining'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<EventCubit>(),  // Pass current cubit
                              child: EventPage(event: event),  // Pass the event to be edited
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => context.read<EventCubit>().deleteEvent(event.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is EventError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('Start by adding an event.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<EventCubit>(),
              child: EventPage(),  // No event means we are creating a new one
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
