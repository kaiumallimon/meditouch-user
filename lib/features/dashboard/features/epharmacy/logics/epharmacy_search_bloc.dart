import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/repository/epharmacy_search_repository.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_search_event.dart';

import 'epharmacy_search_state.dart';

class EpharmacySearchBloc
    extends Bloc<EpharmacySearchEvent, EpharmacySearchState> {
  EpharmacySearchBloc() : super(EpharmacySearchInitial()) {
    on<EpharmacySearchQueryEvent>((event, emit) async {
      // initial state: loading
      emit(EpharmacySearchLoading());

      // process the query to server
      final List<Medicine>? medicines =
          await EpharmacySearchRepository().searchMedicine(event.query);

      // check if the result is null
      if (medicines == null) {
        emit(EpharmacySearchError(
            message: 'Failed to load medicines', query: event.query));
      } else {
        emit(EpharmacySearchSuccess(medicines: medicines, query: event.query));
      }
    });

    on<EpharmacySearchClearEvent>((event, emit) {
      emit(EpharmacySearchInitial());
    });
  }
}
