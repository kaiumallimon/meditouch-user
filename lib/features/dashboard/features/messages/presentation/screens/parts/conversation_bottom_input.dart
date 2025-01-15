import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/model/message_model.dart';
import '../../../data/repository/messages_repository.dart';

Container bottomInputField(ColorScheme theme, String conversationId,
    TextEditingController messageController, String doctorId, String userId) {
  return Container(
    height: 80,
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    color: theme.surfaceContainer,
    child: Row(
      children: [
        // image picker
        IconButton(onPressed: () {}, icon: const Icon(Icons.image)),

        const SizedBox(width: 5),

        // text field
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: const TextStyle(fontSize: 14),
              controller: messageController,
              maxLines: null,
              enableSuggestions: true,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: theme.onSurface.withOpacity(.5)),
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
            onPressed: () {
              final String content = messageController.text.trim();

              if (content.isEmpty) return;

              MessagesRepository().sendMessage(
                  conversationId,
                  MessageModel(
                      conversationId: conversationId,
                      from: 'patient',
                      content: content,
                      isRead: false,
                      receiverId: doctorId,
                      senderId: userId,
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      type: 'text'));

              // clear the input field
              messageController.clear();
            },
            icon: const Icon(Icons.send)),
      ],
    ),
  );
}
