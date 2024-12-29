import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/shared_repository.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/epharmacy_states.dart';

import '../data/repository/epharmacy_repository.dart';
import 'epharmacy_events.dart';

class EpharmacyBloc extends Bloc<EpharmacyEvents, EpharmacyStates> {
  EpharmacyBloc() : super(const EpharmacyInitialState()) {
    on<EpharmacyRefreshEvent>(_refreshEpharmacy);
  }

  Future<void> _refreshEpharmacy(
      EpharmacyRefreshEvent event, Emitter<EpharmacyStates> emit) async {
    emit(const EpharmacyLoadingState());

    // get the build id from shared repository
    final buildIdData = await SharedRepository().getBuildId();

    // request data from the server
    final MedicinesResponse? medicineResponse = await EpharmacyRepository()
        .getMedicines(buildIdData, event.currentPage);

    if (medicineResponse != null) {
      emit(EpharmacySuccessState(
        currentPage: event.currentPage,
        medicines: medicineResponse.medicines,
        totalPages: medicineResponse.totalPages, // Pass totalPages here
        message: 'Success',
      ));
    } else {
      emit(const EpharmacyErrorState(message: 'Error occurred'));
    }
  }
}
