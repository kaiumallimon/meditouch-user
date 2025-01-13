import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';

class AppointmentBookScreen extends StatelessWidget {
  const AppointmentBookScreen(
      {super.key,
      required this.date,
      required this.timeSlotIndex,
      required this.doctor});

  final String date;
  final int timeSlotIndex;
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    // get the theme
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
        child: Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        title: const Text(
          "Book an appointment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.surfaceContainer,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Doctor info
            ///
            ///
            ///
            /// Doctor details card
            Text(
              'Doctor Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: doctor.imageUrl,
                      height: 140,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: theme.primary,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            doctor.specialization,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('Appointment time:',
                            style: TextStyle(
                                color: theme.onSurface.withOpacity(.5))),
                        const SizedBox(height: 5),
                        Text(
                          '$date (${doctor.timeSlots[date]![timeSlotIndex]['time']})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: theme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Doctor fee card
            ///
            ///

            const SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visiting Fee',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: theme.onSurface.withOpacity(.5),
                    ),
                  ),
                  Text(
                    'BDT. ${doctor.visitingFee}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Patient info card
            ///
            ///
            ///
            ///
            Text(
              'Patient Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),

            const SizedBox(height: 15),

            FutureBuilder(
                future: HiveRepository().getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    final user = snapshot.data;
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: user!['image'],
                              height: 170,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: theme.onSurface.withOpacity(.5),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      user!['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: theme.onSurface.withOpacity(.5),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      user['email'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Phone',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: theme.onSurface.withOpacity(.5),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      user['phone'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),

            const SizedBox(height: 20),

            /// Continue
            ///
            /// to
            ///
            /// payment
            ///
            ///
            /// to book the appointment
            Text(
              'Go ahead and pay the visiting fee to book the appointment.',
              style: TextStyle(
                color: theme.onSurface.withOpacity(.5),
              ),
            ),

            const SizedBox(height: 20),

            CustomButton(
                size: Size(600, 50),
                text: "Pay now",
                onPressed: () {},
                bgColor: theme.primary,
                fgColor: theme.onPrimary,
                isLoading: false)
          ],
        ),
      ),
    ));
  }
}
