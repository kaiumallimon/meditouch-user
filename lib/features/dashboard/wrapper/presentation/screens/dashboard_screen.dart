import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/common/push_notification/notification_service.dart';
import 'package:meditouch/features/ai-chat/presentation/screens/ai_model_chat.dart';
import 'package:meditouch/features/ai-medication/presentation/view/ai_medication.dart';
import 'package:meditouch/features/dashboard/features/account/presentation/screens/account_screen.dart';
import 'package:meditouch/features/dashboard/features/appointments/appointments.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/epharmacy.dart';
import 'package:meditouch/features/dashboard/features/home/home.dart';
import 'package:meditouch/features/dashboard/features/messages/messages.dart';
import 'package:meditouch/features/dashboard/navigation/navbar/custom_navbar.dart';

import '../../../navigation/logics/navigation_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.firebaseInit(context);
    notificationService.setupInteractedMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    // retain status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // get theme
    final colorScheme = Theme.of(context).colorScheme;

    // // set status bar and nav themes
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: colorScheme.surfaceContainer,
    //     statusBarIconBrightness: colorScheme.brightness,
    //     systemNavigationBarColor: Color.alphaBlend(
    //       colorScheme.primary.withOpacity(0.08), // Tint effect
    //       colorScheme.surface,
    //     ),
    //     systemNavigationBarIconBrightness: colorScheme.brightness));

    return Scaffold(
        backgroundColor: colorScheme.surfaceContainer,
        body: SafeArea(
          child: BlocBuilder<NavigationCubit, int>(
              builder: (context, state) => screens[state]),
        ),
        bottomNavigationBar: const CustomFloatingNavigationBar(),

        // floatingActionButton:
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AiModelChatScreen()));
                },
                icon: Icon(Icons.chat, color: Colors.black, size: 20),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(colorScheme.secondary),
                  shape: MaterialStateProperty.all(CircleBorder()),
                  elevation: MaterialStateProperty.all(5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () async {
                  // capture image
                  XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.camera, imageQuality: 50);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AiMedication(
                            medicineImage: image!,
                          )));
                },
                icon: Icon(Icons.camera_alt,
                    color: colorScheme.onPrimary, size: 20),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(colorScheme.primary),
                  shape: MaterialStateProperty.all(CircleBorder()),
                  elevation: MaterialStateProperty.all(5),
                ),
              ),
            ),
          ],
        ));
  }

  final List<Widget> screens = [
    const HomeScreen(),
    const EpharmacyScreen(),
    const AppointmentScreen(),
    const MessagesScreen(),
    const AccountScreen()
  ];
}
