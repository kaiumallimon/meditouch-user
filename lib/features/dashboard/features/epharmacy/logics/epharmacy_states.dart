import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

abstract class EpharmacyStates extends Equatable {
  const EpharmacyStates();

  @override
  List<Object> get props => [];
}

class EpharmacyInitialState extends EpharmacyStates {
  const EpharmacyInitialState();

  @override
  List<Object> get props => [];
}

class EpharmacyLoadingState extends EpharmacyStates {
  const EpharmacyLoadingState();

  @override
  List<Object> get props => [];
}

class EpharmacyErrorState extends EpharmacyStates {
  final String message;

  const EpharmacyErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class EpharmacySuccessState extends EpharmacyStates {
  final String message;
  final int totalPages;
  final List<Medicine> medicines;

  const EpharmacySuccessState(
      {required this.message,
      required this.medicines,
      required this.totalPages});

  @override
  List<Object> get props => [message, totalPages, medicines];
}
