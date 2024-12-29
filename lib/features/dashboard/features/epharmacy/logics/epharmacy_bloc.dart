import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/shared_repository.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_states.dart';

import '../data/repository/epharmacy_repository.dart';
import 'epharmacy_events.dart';

class EpharmacyBloc extends Bloc<EpharmacyEvents, EpharmacyStates> {
  EpharmacyBloc() : super(const EpharmacyInitialState()) {
    on<EpharmacyRefreshEvent>(_refreshEpharmacy);
    on<EpharmacyLoadMoreEvent>(_loadMoreMedicines);
  }

  int _currentPage = 1; // Track current page for pagination

  Future<void> _refreshEpharmacy(
      EpharmacyRefreshEvent event, Emitter<EpharmacyStates> emit) async {
    emit(const EpharmacyLoadingState());

    // get the build id from shared repository
    final buildIdData = await SharedRepository().getBuildId();

    // request data from the server
    final MedicinesResponse? medicineResponse =
        await EpharmacyRepository().getMedicines(buildIdData, 1);

    if (medicineResponse != null) {
      _currentPage = 1; // Reset the page number when refreshing
      emit(EpharmacySuccessState(
        medicines: medicineResponse.medicines,
        totalPages: medicineResponse.totalPages, // Pass totalPages here
        message: 'Success',
      ));
    } else {
      emit(const EpharmacyErrorState(message: 'Error occurred'));
    }
  }

  Future<void> _loadMoreMedicines(
      EpharmacyLoadMoreEvent event, Emitter<EpharmacyStates> emit) async {
    if (state is EpharmacySuccessState) {
      final currentState = state as EpharmacySuccessState;
      final currentMedicines = currentState.medicines;

      // Fetch the next page
      final buildIdData = await SharedRepository().getBuildId();
      final response =
          await EpharmacyRepository().getMedicines(buildIdData, event.page);

      if (response != null) {
        emit(EpharmacySuccessState(
          medicines: currentMedicines + response.medicines,
          totalPages: response.totalPages,
          message: 'Success',
        ));
      } else {
        emit(const EpharmacyErrorState(message: 'Failed to load more data'));
      }
    }
  }
}
