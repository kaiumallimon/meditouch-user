import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_events.dart';

import 'parts/epharmacy_appbar.dart';
import 'parts/epharmacy_scrollable_body.dart';

class EpharmacyScreen extends StatelessWidget {
  const EpharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get theme:
    final theme = Theme.of(context).colorScheme;

    // request refresh
    BlocProvider.of<EpharmacyBloc>(context)
        .add(const EpharmacyRefreshEvent(currentPage: 1));

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // custom appbar
          buildCustomAppBar(context, theme),

          // space
          const SizedBox(height: 10),

          // body
          Expanded(
            child: buildCustomBody(context, theme),
          ),
        ],
      ),
    );
  }
}
