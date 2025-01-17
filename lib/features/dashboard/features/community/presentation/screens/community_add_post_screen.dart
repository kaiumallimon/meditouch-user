import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/dashboard/features/community/data/models/community_model.dart';
import 'package:meditouch/features/dashboard/features/community/data/repository/community_repository.dart';
import 'package:quickalert/quickalert.dart';

class CommunityAddPostScreen extends StatefulWidget {
  const CommunityAddPostScreen({super.key});

  @override
  State<CommunityAddPostScreen> createState() => _CommunityAddPostScreenState();
}

class _CommunityAddPostScreenState extends State<CommunityAddPostScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // image picker function
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        title: const Text("Add a community post"),
        elevation: 0,
        backgroundColor: theme.surfaceContainer,
        surfaceTintColor: theme.surfaceContainer,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image picker: (optional)

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: theme.primary,
                        )
                      : Image.file(File(_image!.path), fit: BoxFit.cover),
                ),
              ),
            ),

            // post input:

            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 3,
                controller: _textController,
                style: TextStyle(color: theme.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Write something here...',
                  hintStyle: TextStyle(color: theme.onSurface.withOpacity(.5)),
                  border: InputBorder.none,
                ),
              ),
            ),

            // post button:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  size: Size(120, 45),
                  text: "Post",
                  onPressed: () async {
                    if (_textController.text.isEmpty && _image == null) {
                      // Show a warning if no text or image is provided
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Post is empty',
                        text: 'Please add text or an image to post.',
                      );
                      return;
                    }

                    // Show loading indicator
                    QuickAlert.show(
                        context: context, type: QuickAlertType.loading);

                    try {
                      // Get user info
                      final user = await HiveRepository().getUserInfo();
                      if (user == null)
                        throw Exception('Failed to fetch user info');

                      String? imageUrl;

                      // If an image is selected, upload it
                      if (_image != null) {
                        imageUrl = await CommunityRepository()
                            .uploadImage(File(_image!.path));
                        if (imageUrl == null)
                          throw Exception('Failed to upload image');
                      }

                      // Add post to Firestore
                      final isPostAdded = await CommunityRepository().addPost(
                        CommunityModel(
                          id: "",
                          reacts: [],
                          comments: [],
                          image: imageUrl,
                          text: _textController.text,
                          postedBy: user['id'],
                          postTime: Timestamp.fromDate(DateTime.now()),
                        ),
                      );

                      // Hide loading indicator
                      Navigator.of(context).pop();

                      if (isPostAdded) {
                        // Show success message
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Post Added',
                          text: 'Your post has been successfully uploaded.',
                        );

                        // Clear text field and image after successful post
                        _textController.clear();
                        setState(() {
                          _image = null;
                        });
                      } else {
                        throw Exception('Failed to add post');
                      }
                    } catch (e) {
                      // Hide loading indicator
                      Navigator.of(context).pop();

                      // Show error message
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error',
                        text: e.toString(),
                      );
                    }
                  },
                  bgColor: theme.primary,
                  fgColor: theme.onPrimary,
                  isLoading: false,
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  final TextEditingController _textController = TextEditingController();
}
