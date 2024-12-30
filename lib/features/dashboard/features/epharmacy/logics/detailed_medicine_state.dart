import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_details_model.dart';

abstract class DetailedMedicineState extends Equatable {
  const DetailedMedicineState();

  @override
  List<Object> get props => [];
}


class DetailedMedicineInitial extends DetailedMedicineState {}

class DetailedMedicineLoading extends DetailedMedicineState {}

class DetailedMedicineSuccess extends DetailedMedicineState {
  final MedicineDetailsModel medicineDetails;
  final int selectedUnitIndex;

  const DetailedMedicineSuccess(this.medicineDetails, this.selectedUnitIndex);  

  @override
  List<Object> get props => [medicineDetails, selectedUnitIndex];
}

class DetailedMedicineError extends DetailedMedicineState {
  final String message;

  const DetailedMedicineError(this.message);

  @override
  List<Object> get props => [message];
}