import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/home/logics/home_event.dart';
import 'package:meditouch/features/dashboard/features/home/presentation/screens/parts/home_grid.dart';
import 'package:shimmer/shimmer.dart';

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
            // return CustomLoadingAnimation(
            //   color: theme.primary,
            //   size: 30,
            // );
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.3),
                    highlightColor: theme.secondary.withOpacity(0.5),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: theme.primary.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.3),
                    highlightColor: theme.secondary.withOpacity(0.5),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      color: theme.primary.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.3),
                    highlightColor: theme.secondary.withOpacity(0.5),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      color: theme.primary.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: theme.primary.withOpacity(0.3),
                    highlightColor: theme.secondary.withOpacity(0.5),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 240,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                              baseColor: theme.primary.withOpacity(0.3),
                              highlightColor: theme.secondary.withOpacity(0.5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ));
                        }),
                  )
                ],
              ),
            );
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
                        const SizedBox(height: 20),
                        buildHomeGridMenu(context, theme)
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

  // Appointment box widget to show upcoming appointments
}
