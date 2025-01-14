import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/messages/logics/messages_bloc.dart';

import 'doctor_messages_search_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    // load messages
    // context.read<MessagesBloc>().add(AllDoctorsEventFetch());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Messages',
            style: TextStyle(
                color: theme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          // Expanded(child: BlocBuilder<MessagesBloc, MessagesState>(
          //     builder: (context, state) {
          //   if (state is MessagesStateLoading ||
          //       state is AllDoctorsStateLoading) {
          //     return const Center(child: CircularProgressIndicator());
          //   } else if (state is MessagesStateLoaded) {
          //     return const Center(child: Text('Messages loaded'));
          //   } else if (state is MessagesStateError) {
          //     return Center(child: Text(state.message));
          //   } else if (state is AllDoctorsStateLoaded) {
          //     if (state.doctors.isEmpty) {
          //       return const Center(child: Text('No doctors found'));
          //     }
          //     return ListView.builder(
          //         itemCount: state.doctors.length,
          //         itemBuilder: (context, index) => ListTile(
          //               title: Text(state.doctors[index].name),
          //               subtitle: Text(state.doctors[index].specialization),
          //             ));
          //   } else {
          //     return const Center(child: Text('Unknown state'));
          //   }
          // })),
          Expanded(
              child: ListView(
            children: [
              // search bar
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => DoctorMessagesSearchScreen()));
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Icon(Icons.search,
                          color: theme.onSurface.withOpacity(.5)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search for doctors you have appointments with',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: theme.onSurface.withOpacity(.5)),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
