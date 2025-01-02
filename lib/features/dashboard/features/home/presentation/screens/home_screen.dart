import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditouch/common/utils/datetime_format.dart';
import 'package:meditouch/common/widgets/custom_loading_animation.dart';
import 'package:meditouch/features/dashboard/features/home/logics/home_event.dart';
import 'package:meditouch/features/dashboard/navigation/logics/navigation_cubit.dart';
import 'package:r_icon_pro/r_icon_pro.dart';

import '../../../../../../common/widgets/custom_tinted_iconbutton.dart';
import '../../logics/home_bloc.dart';
import '../../logics/home_state.dart';

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
                  _buildSliverAppbar(context, theme, userInfo),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 10),
                        _buildDateAndTime(theme),
                        const SizedBox(height: 10),
                        _buildGreeting(theme, userInfo['name']),
                        const SizedBox(height: 20),
                        _buildAppointmentBox(theme, 2),
                        const SizedBox(height: 20),
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
  Widget _buildAppointmentBox(ColorScheme theme, int count) {
    return BlocBuilder<NavigationCubit, int>(builder: (context, state) {
      return GestureDetector(
        onTap: () {
          context.read<NavigationCubit>().switchTo(2);
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        RIcon.Calendar,
                        color: theme.onPrimary,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Appointments',
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "You have $count upcoming appointments",
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.onPrimary.withOpacity(0.7),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color: theme.onPrimary.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Date and time widget
  Text _buildDateAndTime(ColorScheme theme) {
    return Text(
      DateTimeFormatUtil().getCurrentFormattedDateDashboard(),
      style: TextStyle(
          fontSize: 14, color: theme.onSurface.withOpacity(.7), height: 1
          // fontWeight: FontWeight.w600,
          ),
    );
  }

  // Greeting widget
  Widget _buildGreeting(ColorScheme theme, String name) {
    return Text(
      "Hi, $name",
      style: TextStyle(fontSize: 18, color: theme.onSurface, height: 1),
    );
  }

  // Sliver appbar widget
  SliverAppBar _buildSliverAppbar(
      BuildContext context, ColorScheme theme, Map<String, dynamic> userData) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      toolbarHeight: 60,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: null,
      backgroundColor: theme.surfaceContainer,
      automaticallyImplyLeading: false,
      flexibleSpace: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User image in leading
            Container(
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: userData['image'],
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person), // Fallback icon
                ),
              ),
            ),
            const Spacer(),

            // Notification and search icons in actions
            Row(
              children: [
                CustomTintedIconButton(
                  child: Image.asset(
                    'assets/icons/notification.png',
                    height: 25,
                    width: 25,
                    color: theme.primary,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoaded) {
                      return CustomTintedIconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/cart');
                        },
                        hasCount: true,
                        count: state.cartItemsCount,
                        child: Icon(Icons.shopping_bag_outlined,
                            color: theme.primary),
                      );
                    }

                    return CustomTintedIconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/cart');
                      },
                      hasCount: false,
                      child: Icon(Icons.shopping_bag_outlined,
                          color: theme.primary),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
