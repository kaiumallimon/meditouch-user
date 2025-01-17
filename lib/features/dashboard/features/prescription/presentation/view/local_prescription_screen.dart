import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/common/widgets/image_view_remote.dart';
import 'package:meditouch/features/dashboard/features/prescription/data/repository/prescription_repository.dart';

class LocalPrescriptionScreen extends StatelessWidget {
  const LocalPrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Prescriptions',
            style: TextStyle(color: theme.onSurface, fontSize: 16)),
        backgroundColor: theme.surfaceContainer,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
            future: HiveRepository().getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CustomLoadingAnimation(size: 25, color: theme.primary),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final user = snapshot.data!;

              return StreamBuilder(
                  stream: PrescriptionRepository()
                      .getLocalPrescriptions(user['id']),
                  builder: (context, prescriptionsSnapshot) {
                    if (prescriptionsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CustomLoadingAnimation(
                            size: 25, color: theme.primary),
                      );
                    }

                    if (prescriptionsSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${prescriptionsSnapshot.error}'),
                      );
                    }

                    final prescriptions = prescriptionsSnapshot.data!;

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 20),
                      itemCount: prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = prescriptions[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ImageViewer(imageUrl: prescription.prescription);
                            }));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16), // Added more space between items
                            decoration: BoxDecoration(
                              color: theme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: prescription.prescription,
                                    progressIndicatorBuilder: (context, url, downloadProgress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          color: theme.primary,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12), // Added padding for the content
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        prescription.description,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: theme.onPrimaryContainer,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        formatTimestamp(prescription.timeStamp),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: theme.onPrimaryContainer.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                    );
                  });
              // return StreamBuilder(stream: stream, builder: builder)
            }),
      )),
    );
  }
}

String formatTimestamp(Timestamp timestamp) {
  final date = timestamp.toDate();
  return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute} ${date.hour > 12 ? 'PM' : 'AM'}';
}
