// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'detailed_doctor_state.dart';
// import '../data/repository/doctor_repository.dart';

// // detailed_doctor_state.dart

// class DetailedDoctorState {
//   final DateTime firstDate;
//   final DateTime lastDate;
//   final DateTime focusedDate;

//   DetailedDoctorState({
//     required this.firstDate,
//     required this.lastDate,
//     required this.focusedDate,
//   });
// }


// // detailed_doctor_cubit.dart



// class DetailedDoctorCubit extends Cubit<DetailedDoctorState> {
//   final DoctorRepository _repository;

//   DetailedDoctorCubit({
//     required String doctorId,
//     DoctorRepository? repository,
//   })  : _repository = repository ?? DoctorRepository(),
//         super(DetailedDoctorState(
//           firstDate: DateTime.now(),
//           lastDate: DateTime.now().add(const Duration(days: 30)),
//           focusedDate: DateTime.now(),
//         )) {
//     _initializeDoctorSchedule(doctorId);
//   }

//   // Initialize the doctor schedule by fetching the last available date
//   Future<void> _initializeDoctorSchedule(String doctorId) async {
//     try {
//       final lastDate = await _repository.fetchLastDayOfDoctorSchedule(doctorId);
//       emit(DetailedDoctorState(
//         firstDate: DateTime.now(),
//         lastDate: lastDate,
//         focusedDate: DateTime.now(),
//       ));
//     } catch (_) {
//       // If fetching fails, use a fallback last date
//       emit(DetailedDoctorState(
//         firstDate: DateTime.now(),
//         lastDate: DateTime.now().add(const Duration(days: 30)),
//         focusedDate: DateTime.now(),
//       ));
//     }
//   }

//   // Change the focused date
//   void changeFocusedDate(DateTime focusedDate) {
//     final currentState = state;
//     emit(DetailedDoctorState(
//       firstDate: currentState.firstDate,
//       lastDate: currentState.lastDate,
//       focusedDate: focusedDate,
//     ));
//   }
// }
