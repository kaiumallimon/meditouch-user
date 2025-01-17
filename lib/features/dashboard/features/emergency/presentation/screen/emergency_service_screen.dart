import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import '../../data/repository/emergency_repository.dart';

class EmergencyService extends StatefulWidget {
  const EmergencyService(
      {super.key, required this.currentLocation, required this.userId});

  final LatLng currentLocation;
  final String userId;

  @override
  _EmergencyServiceState createState() => _EmergencyServiceState();
}

class _EmergencyServiceState extends State<EmergencyService> {
  String? selectedService; // Variable to hold selected service

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              vPadding: 15,
              hasBackButton: true,
              backButtonBorderColor: theme.primary.withOpacity(.3),
              subtitle: 'Get an emergency service now',
              title: 'Emergency Service',
              textColor: theme.primary,
              textSize: 18,
              bgColor: theme.surface,
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.8, // Responsive width
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.primary.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Select Service",
                        style: TextStyle(color: theme.primary), // Hint color
                      ),
                      value: selectedService,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedService = newValue;
                        });
                      },
                      items: <String>['Fire Service', 'Ambulance']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize:
                                screenWidth * 0.04, // Responsive font size
                                color: theme.onSurface,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      underline: SizedBox(), // Remove the default underline
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: theme
                            .primary, // Change icon color to match the theme
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1), // Responsive spacing

                  AvatarGlow(
                    glowColor: theme.primary.withOpacity(0.5),
                    glowRadiusFactor: .2,
                    child: GestureDetector(
                      onLongPress: () {
                        // showCustomLoadingDialog(context);

                        if (selectedService == null) {
                          showCustomAlert(
                              context,
                              "Please select a service first!",
                              theme.error,
                              theme.onError, true);
                          return;
                        }

                        showCustomLoadingDialog(context);

                        FirebaseEmergencyService().sendEmergencyRequest({
                          'userId': widget.userId,
                          'service': selectedService,
                          'location': {
                            'latitude': widget.currentLocation.latitude,
                            'longitude': widget.currentLocation.longitude,
                          },
                          'status': 'pending',
                          'requestTime': FieldValue.serverTimestamp(),
                        }).then((_) {
                          hideCustomLoadingDialog(context);
                          Navigator.pop(context);
                          Navigator.pop(context);

                          showCustomAlert(
                              context,
                              "Emergency request sent, we will contact your shortly!",
                              CupertinoColors.activeGreen,
                              Colors.white, false);
                        }).catchError((error) {
                          hideCustomLoadingDialog(context);
                          showCustomAlert(context, error.toString(),
                              theme.error, theme.onError, true);
                        });
                      },
                      child: Container(
                        height: screenWidth * 0.4, // Responsive height
                        width: screenWidth * 0.4, // Responsive width
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primary,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.sos,
                            color: theme.onPrimary,
                            size: screenWidth * 0.25, // Responsive icon size
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1), // Responsive spacing

                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1), // Responsive padding
                    child: Text(
                      'Select a service and press & hold the SOS button to request help!',
                      style: TextStyle(
                        color: theme.onSurface,
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                      textAlign: TextAlign
                          .center, // Center text for better readability
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomAlert(
      BuildContext context, String message, Color bgColor, Color fgColor, bool error) {
    QuickAlert.show(
        context: context,
        type: error? QuickAlertType.error: QuickAlertType.success,
        text: message,
        barrierDismissible: false);
  }
}