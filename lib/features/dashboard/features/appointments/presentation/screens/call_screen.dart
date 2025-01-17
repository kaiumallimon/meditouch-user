import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../../../common/constants/secrets.dart';

// class InformationScreen extends StatelessWidget {
//   InformationScreen(
//       {super.key, required this.userId, required this.userName});
//
//   final String userId;
//   final String userName;
//   final callIdController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(child: Text('$userId')),
//             const SizedBox(
//               height: 10,
//             ),
//             Center(child: Text(userName)),
//             const SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: callIdController,
//               decoration: InputDecoration(hintText: "Enter call id"),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () {
//                     final String callId = callIdController.text.trim();
//
//                     if (callId.isEmpty) {
//                       Get.snackbar('Error', "Please enter a call id",
//                           backgroundColor: Colors.red, colorText: Colors.white);
//                       return;
//                     }
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => CallScreen(
//                             doctorId: userId,
//                             doctorName: userName,
//                             callId: callId)));
//                   },
//                   child: Text('Start Call')),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class CallScreen extends StatelessWidget {
  const CallScreen(
      {super.key,
      required this.userId,
      required this.userName,
      required this.image,
      required this.callId});

  final String userId;
  final String userName;
  final String callId;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: AppSecrets().zegoId,
          appSign: AppSecrets().zegoSign,
          callID: callId,
          userID: userId,
          userName: userName,
          onDispose: () async {
            // exit the call
            Navigator.of(context).pop();
          },
          config: ZegoUIKitPrebuiltCallConfig()
            ..avatarBuilder = (BuildContext context, Size size,
                ZegoUIKitUser? user, Map extraInfo) {
              return CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(image),
                onBackgroundImageError: (_, __) => Icon(Icons.person),
              );
            },
        ),
      ),
    );
  }
}
