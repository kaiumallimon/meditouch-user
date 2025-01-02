import 'package:flutter/cupertino.dart';
import 'package:meditouch/app/app_exporter.dart';
import '../../logics/epharmacy_search_state.dart';
import 'parts/epharmacy_search_appbar.dart';
import 'parts/epharmacy_search_initial.dart';
import 'parts/epharmacy_search_result.dart';

class EpharmacySearchScreen extends StatelessWidget {
  EpharmacySearchScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Provide EpharmacySearchBloc to the widget tree
    return BlocProvider(
      create: (context) => EpharmacySearchBloc(),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context).colorScheme;

          // SET STATUS BAR COLOR

          return SafeArea(
            child: Scaffold(
              backgroundColor: theme.surfaceContainer,
              appBar: searchAppBar(theme, context, _searchController),
              body: BlocBuilder<EpharmacySearchBloc, EpharmacySearchState>(
                builder: (context, state) {
                  // Show the search input field and search history
                  if (state is EpharmacySearchInitial) {
                    return buildEpharmacySearchInitialState(
                        theme, _searchController, context);
                  }

                  // Show loading indicator while searching
                  if (state is EpharmacySearchLoading) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        radius: 12,
                        color: theme.primary,
                      ),
                    );
                  }

                  // Show error message if the search failed
                  if (state is EpharmacySearchError) {
                    return Center(child: Text(state.message));
                  }

                  // Show the search results
                  if (state is EpharmacySearchSuccess) {
                    return buildSearchResults(state, theme);
                  }

                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
