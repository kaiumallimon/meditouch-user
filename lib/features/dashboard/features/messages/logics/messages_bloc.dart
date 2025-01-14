import 'dart:async';

import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/messages/data/repository/messages_repository.dart';

import '../../doctors/data/models/doctor_model.dart';

abstract class MessagesSearchEvent {}


class AllDoctorsEventFetch extends MessagesSearchEvent {}

// state

abstract class MessagesSearchState {}

class MessagesSearchStateInitial extends MessagesSearchState {}


class AllDoctorsStateLoading extends MessagesSearchState {}

class AllDoctorsStateLoaded extends MessagesSearchState {
  final List<DoctorModel> doctors;

  AllDoctorsStateLoaded({required this.doctors});
}

class AllDoctorsStateError extends MessagesSearchState {
  final String message;

  AllDoctorsStateError({required this.message});
}

// bloc

class MessagesSearchBloc extends Bloc<MessagesSearchEvent, MessagesSearchState> {
  MessagesSearchBloc() : super(MessagesSearchStateInitial()) {
    on<AllDoctorsEventFetch>(_onAllDoctorsEventFetch);
  }

  // all doctors
  FutureOr<void> _onAllDoctorsEventFetch(
      AllDoctorsEventFetch event, Emitter<MessagesSearchState> emit) async {
    emit(AllDoctorsStateLoading());

    try {
      final userData = await HiveRepository().getUserInfo();
      final List<DoctorModel> doctors = await MessagesRepository()
          .findDoctorsWithAppointments(userData!['id']);
      emit(AllDoctorsStateLoaded(doctors: doctors));
    } catch (e) {
      emit(AllDoctorsStateError(message: 'Error fetching doctors: $e'));
    }
  }
}
