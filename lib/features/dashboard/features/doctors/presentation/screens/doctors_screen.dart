import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/common/widgets/custom_tinted_iconbutton.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/repository/review_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/models/doctor_model.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/doctors_bloc.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/doctors_state.dart';

import '../../logics/doctors_event.dart';
import 'doctor_detailed_page.dart';
import 'doctor_search_screen.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // get theme
    final theme = Theme.of(context).colorScheme;

    // set status bar and nav themes
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.surfaceContainer,
      statusBarIconBrightness: theme.brightness,
      systemNavigationBarColor: Color.alphaBlend(
        theme.primary.withOpacity(0.08), // Tint effect
        theme.surface,
      ),
      systemNavigationBarIconBrightness: theme.brightness,
    ));

    // fetch doctors
    context.read<DoctorsBloc>().add(DoctorsEventFetch());

    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: theme.surfaceContainer,
        title: const Text('Doctors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: theme.surfaceContainer,
        toolbarHeight: 70,
        actions: [
          CustomTintedIconButton(
              child: const Icon(Icons.search_rounded), onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DoctorSearchScreen()));
          }),
          const SizedBox(width: 13),
        ],
      ),
      body: SafeArea(child: buildDoctorsBody(context, theme)),
    );
  }

  Widget buildDoctorsBody(BuildContext context, ColorScheme theme) {
    return BlocBuilder<DoctorsBloc, DoctorsState>(
      builder: (context, state) {
        if (state is DoctorsStateLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DoctorsStateSuccess) {
          final specializations = state.doctors
              .map((doctor) => doctor.specialization)
              .toSet()
              .toList();
          return DefaultTabController(
            length: specializations.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  dividerColor: theme.primary.withOpacity(.1),
                  tabs: specializations
                      .map((specialization) => Tab(
                            text: specialization,
                          ))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: specializations.map((specialization) {
                      final filteredDoctors = state.doctors
                          .where((doctor) =>
                              doctor.specialization == specialization)
                          .toList();
                      return buildDoctorsList(filteredDoctors, theme);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is DoctorsStateFailure) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  Widget buildDoctorsList(List<dynamic> doctors, ColorScheme theme) {
    return ListView.builder(
      itemCount: doctors.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemBuilder: (context, index) {
        DoctorModel doctor = doctors[index];
        return FutureBuilder<double>(
          future: ReviewRepository().calculateRating(doctor.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomLoadingAnimation(size: 20, color: theme.primary));
            }

            double rating = snapshot.data ?? 0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailedPage(doctor: doctor, rating: rating,),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                          color: theme.primary.withOpacity(.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ]),
                child: Row(
                  spacing: 20,
                  children: [
                    // Doctor image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: doctor.imageUrl,
                        width: 100,
                        height: 130,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Center(
                            child: CustomLoadingAnimation(
                                size: 15, color: theme.onPrimary),
                          );
                        },
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          // Doctor name
                          Text(doctor.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  height: 1.2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.onPrimary)),

                          // Doctor specialization
                          Text(doctor.specialization,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  color: theme.onPrimary.withOpacity(.6))),

                          const SizedBox(),

                          // Doctor rating
                          Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.star,
                                  color: theme.onPrimary.withOpacity(.5), size: 16),
                              Text(
                                  rating == 0
                                      ? 'No ratings yet'
                                      : "Rating: $rating",
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: 13,
                                      color: theme.onPrimary.withOpacity(.5))),
                            ],
                          ),

                          const SizedBox(),

                          // district:
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: theme.secondary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: Colors.black, size: 16),
                                const SizedBox(width: 5),
                                Text(doctor.district,
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ],
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
        );
      },
    );
  }
}

String calculateRating(List<Rating> ratings) {
  var value = 0.0;

  for (var rating in ratings) {
    value += rating.value;
  }

  return (value / ratings.length).toStringAsFixed(1);
}
