import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/repository/hive_repository.dart';
import '../../../logics/epharmacy_search_bloc.dart';
import '../../../logics/epharmacy_search_event.dart';
import 'epharmacy_search_clear.dart';

AppBar searchAppBar(ColorScheme theme, BuildContext context,
      TextEditingController searchController) {
    return AppBar(
              title: Container(
                decoration: BoxDecoration(
                  color: theme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    (context as Element).markNeedsBuild();
                  },
                  onSubmitted: (value) async {
                    final query = searchController.text;
                    if (query.isNotEmpty) {
                      await HiveRepository()
                          .saveUserSearchHistory(query.toLowerCase());

                      // Use context.read to get the bloc instance and add the event
                      context.read<EpharmacySearchBloc>().add(
                            EpharmacySearchQueryEvent(query: query),
                          );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for medicines',
                    hintStyle: TextStyle(
                      color: theme.onSurface.withOpacity(.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              elevation: 0,
              backgroundColor: theme.surfaceContainer,
              surfaceTintColor: theme.surfaceContainer,
              centerTitle: false,
              actions: [
                searchClear(theme, searchController),
                const SizedBox(width: 10),
              ],
            );
  }