import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_search_bloc.dart';

import '../../../logics/epharmacy_search_event.dart';

ValueListenableBuilder<TextEditingValue> searchClear(
    ColorScheme theme, TextEditingController searchController) {
  return ValueListenableBuilder<TextEditingValue>(
    valueListenable: searchController,
    builder: (context, value, child) {
      if (value.text.isNotEmpty) {
        return IconButton(
          icon: Icon(
            Icons.clear,
            color: theme.error,
          ),
          onPressed: () {
            searchController.clear();
            searchController.notifyListeners();

            context.read<EpharmacySearchBloc>().add(
                  const EpharmacySearchClearEvent(),
                );
          },
        );
      }

      return const SizedBox();
    },
  );
}
