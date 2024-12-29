import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

Widget buildSearchBar(BuildContext context, ColorScheme theme) {
    return SliverToBoxAdapter(
      child: InkWell(
        splashColor: theme.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: 'Search feature is not available yet',
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: theme.primary.withOpacity(.1), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: theme.primary.withOpacity(.5),
              ),
              const SizedBox(width: 10),
              Text(
                'Search for medicines',
                style: TextStyle(
                    color: theme.primary.withOpacity(.5),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }