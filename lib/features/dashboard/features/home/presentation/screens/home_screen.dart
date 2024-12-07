import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/common/widgets/custom_button.dart';
import 'package:meditouch/features/auth/login/data/repository/login_repository.dart';
import 'package:r_icon_pro/r_icon_pro.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme
    final theme = Theme.of(context).colorScheme;

    return FutureBuilder<Map<String, dynamic>?>(
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                // top row (profile picture, notification, search)

                _buildTopRow(context, theme, snapshot.data!),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTopRow(
      BuildContext context, ColorScheme theme, Map<String, dynamic> userData) {
    print(userData);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // left side: Profile picture

        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: userData['image'],
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),

        CustomButton(
            size: Size(300, 50),
            text: 'Logout',
            onPressed: () async {
              await LoginRepository().logout(context);
            },
            bgColor: theme.error,
            fgColor: theme.onError,
            isLoading: false)
      ],
    );
  }
}

/*

CustomButton(
            size: Size(300, 50),
            text: 'Logout',
            onPressed: () async {
              await LoginRepository().logout(context);
            },
            bgColor: theme.error,
            fgColor: theme.onError,
            isLoading: false)

 */
