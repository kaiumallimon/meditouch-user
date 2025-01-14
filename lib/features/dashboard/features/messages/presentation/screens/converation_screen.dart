import 'package:flutter/material.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/messages/data/model/message_model.dart';
import 'package:meditouch/features/dashboard/features/messages/data/repository/messages_repository.dart';

class ConverationScreen extends StatelessWidget {
  const ConverationScreen(
      {super.key,
      required this.userId,
      required this.doctorId,
      required this.doctor});

  final String doctorId;
  final String userId;
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(doctor.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
        elevation: 0,
      ),
      body: FutureBuilder<String>(
          future: MessagesRepository().createConversation(userId, doctorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomLoadingAnimation(
                  size: 25,
                  color: theme.primary,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final conversationId = snapshot.data!;

            return SafeArea(
              child: StreamBuilder<List<MessageModel>>(
                stream: MessagesRepository().getMessages(conversationId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CustomLoadingAnimation(
                        size: 25,
                        color: theme.primary,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final messages = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Messages list
                      Expanded(
                        child: messages.isEmpty
                            ? const Center(
                                child: Text('No messages yet!'),
                              )
                            : ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];

                                  return ListTile(
                                    title: Text(message.content),
                                    subtitle:
                                        Text(message.timestamp.toString()),
                                  );
                                },
                              ),
                      ),

                      // Input field
                      Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: theme.surfaceContainer,
                        child: Row(
                          children: [
                            // image picker
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.image)),

                            const SizedBox(width: 5),

                            // text field
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.surface,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  maxLines: null,
                                  enableSuggestions: true,
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    hintStyle: TextStyle(
                                        color: theme.onSurface.withOpacity(.5)),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            // send button
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.send)),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
