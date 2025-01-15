import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/messages/data/model/message_model.dart';
import 'package:meditouch/features/dashboard/features/messages/data/repository/messages_repository.dart';

import '../../../../../../common/widgets/image_view_remote.dart';
import 'parts/conversation_bottom_input.dart';

class ConverationScreen extends StatelessWidget {
  ConverationScreen(
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

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });

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
                                controller: _scrollController,
                                physics: BouncingScrollPhysics(),
                                itemCount: messages.length,
                                padding: EdgeInsets.only(bottom: 20, top: 20),
                                itemBuilder: (context, index) {
                                  final message = messages[index];

                                  return buildMessageCard(
                                      context, theme, message, doctorId);
                                },
                              ),
                      ),

                      // Input field
                      bottomInputField(context, theme, conversationId,
                          _messageController, doctorId, userId),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _messageController = TextEditingController();
}

Widget buildMessageCard(BuildContext context, ColorScheme theme,
    MessageModel message, String doctorId) {
  return Align(
    alignment: message.from == 'doctor' && message.senderId == doctorId
        ? Alignment.centerLeft
        : Alignment.centerRight,
    child: message.type == 'text'
        ? Container(
            constraints: const BoxConstraints(
              maxWidth: 200,
            ),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: message.from == 'doctor'
                  ? theme.onPrimary.withOpacity(.1)
                  : theme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: message.from == 'doctor'
                        ? theme.onSurface
                        : theme.onPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                    height: 5), // Add spacing between message and time
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    formatTime(message
                        .timestamp), // Assuming `message.time` contains the formatted time
                    style: TextStyle(
                      color: theme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageViewer(imageUrl: message.content),
              ));
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: message.content,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: theme.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          formatTime(message.timestamp),
                          style: TextStyle(
                            color: theme.onSurface.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
  );
}

String formatTime(Timestamp timestamp) {
  // output format: 01/01/2021 12:00 PM
  final date = timestamp.toDate();
  final formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(date);
  return formattedDate;
}
