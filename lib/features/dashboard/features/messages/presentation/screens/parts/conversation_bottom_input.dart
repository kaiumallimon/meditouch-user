import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../data/model/message_model.dart';
import '../../../data/repository/messages_repository.dart';

Container bottomInputField(
    BuildContext context,
    ColorScheme theme,
    String conversationId,
    TextEditingController messageController,
    String doctorId,
    String userId) {
  return Container(
    height: 80,
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    color: theme.surfaceContainer,
    child: Row(
      children: [
        // image picker
        IconButton(
            onPressed: () {
              // TODO: Implement image picker
              pickImage().then((image) async {
                if (image == null) return;

                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.loading,
                    barrierDismissible: false);

                // Upload the image to Firebase Storage
                String? url = await MessagesRepository().uploadImage(image);

                if (url == null) {
                  Navigator.of(context).pop();
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: "Failed to send image");
                  return;
                }

                // Send the image URL as a message
                MessagesRepository().sendMessage(
                    conversationId,
                    MessageModel(
                        conversationId: conversationId,
                        from: 'patient',
                        content: url,
                        isRead: false,
                        receiverId: doctorId,
                        senderId: userId,
                        timestamp: Timestamp.fromDate(DateTime.now()),
                        type: 'image'));

                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.image)),

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

Future<XFile?> pickImage() async {
  final ImagePicker picker = ImagePicker();

  try {
    // Pick an image from the gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // Return the selected image (or null if no image is picked)
    return image;
  } catch (e) {
    // Handle errors, e.g., user cancels the picker or permissions are denied
    debugPrint('Error picking image: $e');
    return null;
  }
}
