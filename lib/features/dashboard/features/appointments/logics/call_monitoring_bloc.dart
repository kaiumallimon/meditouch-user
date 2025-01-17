import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/app_exporter.dart';

// Events
abstract class CallMonitoringEvent extends Equatable {
  const CallMonitoringEvent();
  @override
  List<Object?> get props => [];
}

class StartMonitoringCall extends CallMonitoringEvent {
  final String appointmentId;
  const StartMonitoringCall(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class CallActiveEvent extends CallMonitoringEvent {}

class CallEndedEvent extends CallMonitoringEvent {}

// States
abstract class CallMonitoringState extends Equatable {
  const CallMonitoringState();
  @override
  List<Object?> get props => [];
}

class CallMonitoringInitial extends CallMonitoringState {}

class CallActive extends CallMonitoringState {}

class CallEnded extends CallMonitoringState {}

// Bloc
class CallMonitoringBloc
    extends Bloc<CallMonitoringEvent, CallMonitoringState> {
  CallMonitoringBloc() : super(CallMonitoringInitial()) {
    on<StartMonitoringCall>(_onStartMonitoringCall);
    on<CallActiveEvent>((event, emit) => emit(CallActive()));
    on<CallEndedEvent>((event, emit) => emit(CallEnded()));
  }

  void _onStartMonitoringCall(
      StartMonitoringCall event, Emitter<CallMonitoringState> emit) {
    final _firestore = FirebaseFirestore.instance;

    _firestore
        .collection('db_client_multi_appointments')
        .doc(event.appointmentId)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data != null && data['isCompleted'] == true) {
        add(CallEndedEvent());
      } else {
        add(CallActiveEvent());
      }
    });
  }
}
