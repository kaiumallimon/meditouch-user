import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:quickalert/quickalert.dart';

import '../../../logics/epharmacy_search_bloc.dart';
import '../../../logics/epharmacy_search_event.dart';

Column buildEpharmacySearchInitialState(ColorScheme theme,
    TextEditingController searchController, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      ValueListenableBuilder(
        valueListenable: HiveRepository().getUserSearchHistoryListenable(),
        builder: (context, Box<List<String>> box, child) {
          final searchHistory = box.get('searchHistory') ?? <String>[];

          if (searchHistory.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  'No search history found.',
                  style: TextStyle(color: theme.onSurface.withOpacity(.5)),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8.0,
              children: searchHistory.map((query) {
                return InkWell(
                  onTap: () {
                    searchController.text = query;
                    searchController.notifyListeners();
                    context.read<EpharmacySearchBloc>().add(
                          EpharmacySearchQueryEvent(query: query),
                        );
                  },
                  child: Chip(
                    color:
                        WidgetStatePropertyAll(theme.primary.withOpacity(.1)),
                    label: Text(query),
                    onDeleted: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: 'Delete Query',
                        confirmBtnColor: theme.error,
                        confirmBtnText: 'Delete',
                        text: 'Are you sure you want to delete this query?',
                        onConfirmBtnTap: () async {
                          await HiveRepository()
                              .deleteSpecificSearchQuery(query);

                          Navigator.pop(context);
                        },
                      );
                    },
                    deleteIcon: Icon(Icons.close,
                        color: theme.onSurface.withOpacity(.5)),
                    backgroundColor: theme.surface,
                    labelStyle: TextStyle(color: theme.onSurface),
                    side: BorderSide(color: theme.primary.withOpacity(.2)),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    ],
  );
}
