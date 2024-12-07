import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/utils/datetime_format.dart';
import 'package:meditouch/common/widgets/custom_appbar.dart';
import 'package:meditouch/common/widgets/custom_list_tile.dart';

import '../../../../../../common/widgets/custom_button.dart';
import '../../../../../auth/login/data/repository/login_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //get theme
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        // Appbar
        CustomAppbar(
          title: 'Profile',
          titleColor: theme.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.primary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleStyle: TextStyle(
            color: theme.primary,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),

        // Profile details (body)

        Expanded(
          child: FutureBuilder<Map<String, dynamic>?>(
              future: HiveRepository().getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: theme.primary,
                      radius: 12,
                    ),
                  );
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                final user = snapshot.data!;

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Profile picture
                      Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: CachedNetworkImage(
                            imageUrl: user['image'],
                            placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // User name
                      Text(
                        user['name'],
                        style: TextStyle(
                          color: theme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // User email
                      CustomListTile(
                          backgroundColor: theme.primary.withOpacity(.1),
                          tile: ListTile(
                            leading: Icon(Icons.email, color: theme.primary),
                            title: Text(
                              'Email',
                              style: TextStyle(
                                color: theme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              user['email'],
                              style: TextStyle(
                                color: theme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          borderRadius: 10),

                      const SizedBox(height: 10),

                      // User phone
                      CustomListTile(
                          backgroundColor: theme.primary.withOpacity(.1),
                          tile: ListTile(
                            leading: Icon(Icons.phone, color: theme.primary),
                            title: Text(
                              'Phone',
                              style: TextStyle(
                                color: theme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              user['phone'],

                              style: TextStyle(
                                color: theme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          borderRadius: 10),

                      const SizedBox(height: 10),

                      // dob

                      CustomListTile(
                          backgroundColor: theme.primary.withOpacity(.1),
                          tile: ListTile(
                            leading: Icon(Icons.cake, color: theme.primary),
                            title: Text(
                              'Date of Birth',
                              style: TextStyle(
                                color: theme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              DateTimeFormatUtil().dobFormatter(user['dob']),
                              style: TextStyle(
                                color: theme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          borderRadius: 10),

                      const SizedBox(height: 10),

                      CustomListTile(
                          backgroundColor: theme.primary.withOpacity(.1),
                          tile: ListTile(
                            leading: Icon(Icons.person, color: theme.primary),
                            title: Text(
                              'Gender',
                              style: TextStyle(
                                color: theme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              user['gender'],
                              style: TextStyle(
                                color: theme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          borderRadius: 10),

                      const SizedBox(height: 15),

                      // // Logout button
                      CustomButton(
                          size: Size(double.infinity, 50),
                          text: 'Logout',
                          onPressed: () async {
                            await LoginRepository().logout(context);
                          },
                          bgColor: theme.error,
                          fgColor: theme.onError,
                          isLoading: false)
                    ],
                  ),
                );
              }),
        )
      ]),
    ));
  }
}
