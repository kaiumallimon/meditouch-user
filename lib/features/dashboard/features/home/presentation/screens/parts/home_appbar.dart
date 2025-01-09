// Sliver appbar widget
  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/widgets/custom_tinted_iconbutton.dart';
import '../../../logics/home_bloc.dart';
import '../../../logics/home_state.dart';

SliverAppBar buildSliverAppbar(
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