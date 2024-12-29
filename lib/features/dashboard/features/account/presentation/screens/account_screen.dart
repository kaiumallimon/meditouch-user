import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/dashboard/features/account/logics/account_states.dart';
import 'package:meditouch/features/dashboard/features/account/presentation/widgets/custom_multipletile.dart';
import 'package:meditouch/features/dashboard/features/account/presentation/widgets/custom_tile.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../navigation/logics/navigation_cubit.dart';
import '../../logics/account_bloc.dart';
import '../../logics/account_events.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // add refresh request
    context.read<AccountBloc>().add(const AccountRefreshRequested());

    // get color scheme
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      color: theme.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Appbar text
          _buildAppbarText(theme),

          const SizedBox(height: 20),

          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              context.read<AccountBloc>().add(const AccountRefreshRequested());
            },
            child: BlocConsumer<AccountBloc, AccountStates>(
              listener: (context, state) {
                if (state is AccountError) {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: state.message);
                }

                if (state is AccountLogout) {
                  // reset the navigation index;
                  context.read<NavigationCubit>().reset();
                  Navigator.of(context).pushReplacementNamed(
                    '/login',
                  );
                }
              },
              builder: (context, state) {
                if (state is AccountLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: theme.primary,
                      radius: 12,
                    ),
                  );
                }

                if (state is AccountError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (state is AccountLoaded) {
                  final userInfo = state.userInfo;

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    children: [
                      //profile picture
                      _buildProfilePicture(theme, userInfo, context),

                      const SizedBox(height: 20),

                      // profile text
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/profile', arguments: userInfo);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Go to profile',
                                style: TextStyle(
                                  color: theme.onSurface.withOpacity(.5),
                                )),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: theme.onSurface.withOpacity(.5),
                              size: 15,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // helper
                      Text('Quick Actions',
                          style: TextStyle(
                            color: theme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),

                      const SizedBox(height: 20),

                      // Account grid
                      _buildAccountGrid(context, theme),

                      const SizedBox(height: 30),

                      // helper
                      Text('Preferences and Management',
                          style: TextStyle(
                            color: theme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),

                      const SizedBox(height: 20),

                      _buildMultipleCustomTile(context, theme),

                      const SizedBox(height: 30),

                      // Logout button
                      _buildLogoutButton(context, theme),
                    ],
                  );
                }

                // return empty container if none of the above
                return const SizedBox();
              },
            ),
          ))
        ],
      ),
    );
  }

  /*Sign out button */
  Widget _buildLogoutButton(BuildContext context, ColorScheme theme) {
    return CustomButton(
        size: const Size(300, 50),
        text: "Logout",
        onPressed: () {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              animType: QuickAlertAnimType.scale,
              barrierDismissible: false,
              text: "Are you sure you want to logout?",
              confirmBtnColor: theme.error,
              confirmBtnText: 'Logout',
              onConfirmBtnTap: () {
                context.read<AccountBloc>().add(const AccountLogoutRequested());
              });
        },
        bgColor: theme.error,
        fgColor: theme.onError,
        isLoading: false);
  }

  /* Multiple custom tile */

  Widget _buildMultipleCustomTile(BuildContext context, ColorScheme theme) {
    return CustomMultipletile(
        backgroundColor: theme.primaryContainer,
        borderRadius: 15,
        seperatorColor: theme.primary.withOpacity(.1),
        padding: 15,
        children: [
          CustomTile(
              leading: Icon(Icons.people, color: theme.primary),
              tileColor: Colors.transparent,
              borderRadius: 0,
              onTap: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: "This feature is not available yet");
              },
              title: Text('View/Manage family members',
                  style: TextStyle(
                    color: theme.onSurface,
                    fontSize: 14,
                  ))),
          CustomTile(
              leading: Icon(Icons.list_alt, color: theme.primary),
              tileColor: Colors.transparent,
              borderRadius: 0,
              onTap: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: "This feature is not available yet");
              },
              title: Text('Your payment logs',
                  style: TextStyle(
                    color: theme.onSurface,
                    fontSize: 14,
                  ))),
          CustomTile(
              leading: Icon(Icons.notifications, color: theme.primary),
              tileColor: Colors.transparent,
              borderRadius: 0,
              onTap: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: "This feature is not available yet");
              },
              title: Text('Notification settings',
                  style: TextStyle(
                    color: theme.onSurface,
                    fontSize: 14,
                  ))),
          CustomTile(
              leading: Icon(Icons.dark_mode, color: theme.primary),
              tileColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pushNamed('/theme');
              },
              borderRadius: 0,
              title: Text('Appearances & Themes',
                  style: TextStyle(
                    color: theme.onSurface,
                    fontSize: 14,
                  ))),
        ]);
  }

  /* 1*2 grid */

  Widget _buildAccountGrid(BuildContext context, ColorScheme theme) {
    // Define grid items as a List of Maps
    final List<Map<String, dynamic>> gridItems = [
      {'icon': Icons.star, 'label': 'Favorites'},
      {'icon': Icons.shopping_bag, 'label': 'Cart'},
      {
        'icon': Icons.receipt_long,
        'label': 'Orders'
      }, // Replaced with a proper icon
      {
        'icon': Icons.bookmark,
        'label': 'Appointments'
      }, // Corrected icon for profile
    ];

    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      mainAxisExtent: 100,
    );

    return SizedBox(
      height: 220, // Adjust height as needed
      child: GridView.builder(
        gridDelegate: gridDelegate,
        itemCount: gridItems.length,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
        itemBuilder: (context, index) {
          final item = gridItems[index];
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'],
                    color: theme.primary,
                    size: 20,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* Profile Picture */
  Widget _buildProfilePicture(
      ColorScheme theme, Map<String, dynamic> userInfo, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/profile');
          },
          child: Container(
            height: 120,
            width: 120,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primary.withOpacity(.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withOpacity(.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: userInfo['image'],
                placeholder: (context, url) => const CupertinoActivityIndicator(
                  radius: 15,
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: theme.onSurface.withOpacity(.5),
                  size: 50,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /* Appbar text */
  Widget _buildAppbarText(ColorScheme theme) {
    return Text(
      'Account & Preferences',
      style: TextStyle(
          color: theme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1),
    );
  }
}
