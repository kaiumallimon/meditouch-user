import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/repository/doctor_repository.dart';
import 'package:meditouch/features/dashboard/features/doctors/logics/doctors_state.dart';

import 'doctors_event.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  DoctorsBloc() : super(DoctorsStateInitial()) {
    on<DoctorsEventFetch>(_fetchDoctors);
  }

  FutureOr<void> _fetchDoctors(
      DoctorsEventFetch event, Emitter<DoctorsState> emit) async {
    emit(DoctorsStateLoading());

    /// fetch doctors from repository
    ///
    /// if success, emit DoctorsStateSuccess
    ///
    /// if failure, emit DoctorsStateFailure

    final doctors = await DoctorRepository().fetchDoctors();

    if (doctors.isNotEmpty) {
      emit(DoctorsStateSuccess(doctors));
    } else {
      emit(DoctorsStateFailure('Failed to fetch doctors'));
    }
  }
}
