import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/appointments/data/repository/review_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/presentation/screens/doctor_detailed_page.dart';
import 'package:meditouch/features/dashboard/features/home/logics/home_event.dart';
import 'package:meditouch/features/dashboard/features/home/presentation/screens/parts/home_grid.dart';
// import 'package:shimmer/shimmer.dart';

import '../../logics/home_bloc.dart';
import '../../logics/home_state.dart';
import 'parts/home_appbar.dart';
import 'parts/home_appointmentcard.dart';
import 'parts/home_datetime.dart';
import 'parts/home_greeting.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    context.read<HomeBloc>().add(HomeRefreshRequested());

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeRefreshRequested());
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return CustomLoadingAnimation(
              color: theme.primary,
              size: 30,
            );
            // return SingleChildScrollView(
            //   physics: const NeverScrollableScrollPhysics(),
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: [
            //       const SizedBox(height: 20),
            //       Shimmer.fromColors(
            //         baseColor: theme.primary.withOpacity(0.3),
            //         highlightColor: theme.secondary.withOpacity(0.5),
            //         child: Container(
            //           height: 50,
            //           width: double.infinity,
            //           color: theme.primary.withOpacity(0.1),
            //         ),
            //       ),
            //       const SizedBox(height: 20),
            //       Shimmer.fromColors(
            //         baseColor: theme.primary.withOpacity(0.3),
            //         highlightColor: theme.secondary.withOpacity(0.5),
            //         child: Container(
            //           height: 20,
            //           width: double.infinity,
            //           color: theme.primary.withOpacity(0.1),
            //         ),
            //       ),
            //       const SizedBox(height: 7),
            //       Shimmer.fromColors(
            //         baseColor: theme.primary.withOpacity(0.3),
            //         highlightColor: theme.secondary.withOpacity(0.5),
            //         child: Container(
            //           height: 40,
            //           width: double.infinity,
            //           color: theme.primary.withOpacity(0.1),
            //         ),
            //       ),
            //       const SizedBox(height: 20),
            //       Shimmer.fromColors(
            //         baseColor: theme.primary.withOpacity(0.3),
            //         highlightColor: theme.secondary.withOpacity(0.5),
            //         child: Container(
            //           height: 120,
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             color: theme.primary.withOpacity(0.1),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 20),
            //       SizedBox(
            //         height: 240,
            //         child: GridView.builder(
            //             gridDelegate:
            //                 const SliverGridDelegateWithFixedCrossAxisCount(
            //               crossAxisCount: 3,
            //               mainAxisSpacing: 10,
            //               crossAxisSpacing: 10,
            //             ),
            //             itemBuilder: (context, index) {
            //               return Shimmer.fromColors(
            //                   baseColor: theme.primary.withOpacity(0.3),
            //                   highlightColor: theme.secondary.withOpacity(0.5),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       color: theme.primary.withOpacity(0.1),
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                   ));
            //             }),
            //       )
            //     ],
            //   ),
            // );
          }

          if (state is HomeError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (state is HomeLoaded) {
            final userInfo = state.userInfo;

            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  buildSliverAppbar(context, theme, userInfo),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 10),
                        buildDateAndTime(theme),
                        const SizedBox(height: 10),
                        buildGreeting(theme, userInfo['name']),
                        const SizedBox(height: 20),
                        buildAppointmentBox(theme, 2),
                        const SizedBox(height: 25),
                        Text('What are you looking for?',
                            style: TextStyle(
                                color: theme.onSurface,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        buildHomeGridMenu(context, theme),
                        const SizedBox(height: 20),
                        // top 5 doctors
                        Text(
                          'Top Rated Doctors',
                          style: TextStyle(
                            color: theme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        buildTopRatedDoctors(theme),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  SizedBox buildTopRatedDoctors(ColorScheme theme) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: StreamBuilder(
          stream: ReviewRepository().getTopRatedDoctors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CustomLoadingAnimation(size: 20, color: theme.primary));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            }

            final data = snapshot.data!;
            // final doctors = data['doctor'];

            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final doctor = data[index]['doctor'];
                final rating = data[index]['rating'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorDetailedPage(
                                doctor: doctor, rating: rating)));
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 170,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: theme.primary,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                  color: theme.primary.withOpacity(.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5))
                            ]),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: doctor.imageUrl,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Center(
                                        child: CustomLoadingAnimation(
                                            size: 15, color: theme.onPrimary));
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              doctor.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.secondary,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            child: Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: theme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  // Appointment box widget to show upcoming appointments
}
