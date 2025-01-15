import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/messages/data/model/message_model.dart';
import 'package:meditouch/features/dashboard/features/messages/data/repository/messages_repository.dart';
import 'package:meditouch/features/dashboard/features/messages/logics/messages_bloc.dart';
import 'package:meditouch/features/dashboard/features/messages/presentation/screens/converation_screen.dart';

import '../../../doctors/data/models/doctor_model.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: [
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text('Recent Messages',
                  style: TextStyle(
                      color: theme.onSurface, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              FutureBuilder(
                  future: HiveRepository().getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    // get user id:
                    final user = snapshot.data!;

                    return StreamBuilder(
                      stream: MessagesRepository().getConversations(user['id']),
                      builder: (context, conversationsResponse) {
                        if (conversationsResponse.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (conversationsResponse.hasError) {
                          return Center(
                              child:
                                  Text(conversationsResponse.error.toString()));
                        } else {
                          final conversations =
                              conversationsResponse.data as List;

                          if (conversations.isEmpty) {
                            return const Center(
                                child: Text('No conversations found'));
                          }

                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: conversations.length,
                              itemBuilder: (context, index) {
                                final conversation =
                                    conversations[index] as ConversationModel;

                                return StreamBuilder(
                                  stream: MessagesRepository()
                                      .getDoctor(conversation.doctorId),
                                  builder: (context, doctorResponse) {
                                    if (doctorResponse.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (doctorResponse.hasError) {
                                      return Center(
                                          child: Text(
                                              doctorResponse.error.toString()));
                                    } else {
                                      final doctor =
                                          doctorResponse.data as DoctorModel;

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ConverationScreen(
                                                        doctor: doctor,
                                                        doctorId: doctor.id,
                                                        userId: user['id'],
                                                      )));
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: theme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      doctor.imageUrl),
                                            ),
                                            title: Text(doctor.name,
                                                style: TextStyle(
                                                    color: theme.onSurface,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Text(
                                                conversation.lastMessageType ==
                                                        'text'
                                                    ? conversation.lastMessage
                                                    : ".",
                                                style: TextStyle(
                                                    color: theme.onSurface
                                                        .withOpacity(.5),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );

                                // return ListTile(
                                //   title: Text(conversation.lastMessage,maxLines: 1, overflow: TextOverflow.ellipsis),
                                // );
                              });
                        }
                      },
                    );
                  })
            ],
          ))
        ],
      ),
    );
  }
}
