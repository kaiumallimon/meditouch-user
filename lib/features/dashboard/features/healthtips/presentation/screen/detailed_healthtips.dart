import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditouch/common/utils/datetime_format.dart';

import '../../../doctors/data/models/doctor_model.dart';
import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import '../../data/model/healthtips_model.dart';

class DetailedHealthServicePage extends StatelessWidget {
  const DetailedHealthServicePage(
      {super.key, required this.healthTips, required this.doctor});

  final HealthTipsModel healthTips;
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                  hasBackButton: true,
                  backButtonBorderColor: theme.primary.withOpacity(.3),
                  title: healthTips.title,
                  textColor: theme.primary,
                  textSize: 18,
                  bgColor: theme.surface),
              const SizedBox(height: 10),
              Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      CachedNetworkImage(
                        imageUrl: healthTips.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        healthTips.title,
                        style: TextStyle(
                            color: theme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        healthTips.body,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: theme.onSurface.withOpacity(.7), fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            formatTimestamp(healthTips.writtenTime),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.primary.withOpacity(.5), fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                doctor.name,
                                style: TextStyle(
                                    color: theme.primary, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                doctor.specialization,
                                style: TextStyle(
                                    color: theme.onSurface.withOpacity(.7),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(doctor.imageUrl),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}

String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return 'Unknown time';
  }

  DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
  // Format the DateTime as desired (e.g., "MM/dd/yyyy, hh:mm a")
  String formattedDate =
  DateFormat('MMMM dd, yyyy, hh:mm a').format(dateTime);
  return formattedDate;
}