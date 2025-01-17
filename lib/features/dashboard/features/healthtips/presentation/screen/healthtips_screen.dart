import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../epharmacy/presentation/screens/load_medicine_from_prescription_screen.dart';
import '../../data/repository/healthtips_repository.dart';
import 'detailed_healthtips.dart';
import 'healthtips_search.dart';


class UserHealthTipsPage extends StatelessWidget {
  const UserHealthTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Health-Tips',
              subtitle: 'Wellness tips written by doctors',
              subtitleColor: theme.onSurface.withOpacity(.5),
              textColor: theme.primary,
              textSize: 18,
              bgColor: theme.surface,
              trailing: ColoredIconButton(
                backgroundColor: theme.primary.withOpacity(.1),
                iconColor: theme.primary,
                assetPath: "assets/icons/search2.png",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HealthTipsSearchPage(),
                    ),
                  );
                },
                width: 36,
                height: 36,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: HealthTipsRepository().getHealthTips(),
                builder: (context, blogSnapshot) {
                  if (blogSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final blogDocs = blogSnapshot.data!;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: blogDocs.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                        stream: HealthTipsRepository()
                            .getDoctorById(blogDocs[index].doctorId),
                        builder: (context, snapshot) {
                          // Check if snapshot has data
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return Center(child: Text("Doctor not found."));
                          }

                          final doctor = snapshot.data!;

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailedHealthServicePage(
                                    healthTips: blogDocs[index],
                                    doctor: doctor,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.primary.withOpacity(.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: blogDocs[index].image,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    blogDocs[index].title,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        'Published on: ',
                                        style: TextStyle(
                                          color: theme.onSurface.withOpacity(.5),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatTimestamp(blogDocs[index].writtenTime),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            doctor.specialization,
                                            style: TextStyle(
                                              color: theme.onSurface.withOpacity(.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(doctor.imageUrl),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ColoredIconButton extends StatelessWidget {
  const ColoredIconButton(
      {super.key,
        required this.backgroundColor,
        required this.iconColor,
        required this.assetPath,
        required this.onPressed,
        required this.width,
        required this.height,
        this.scale});

  final Color backgroundColor;
  final Color iconColor;
  final String assetPath;
  final double width;
  final double height;
  final double? scale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(.3),
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Image.asset(
            assetPath,
            color: iconColor,
            scale: scale ?? 1.6,
          ),
        ),
      ),
    );
  }
}