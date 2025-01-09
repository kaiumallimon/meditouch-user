import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

abstract class MedicineScanState extends Equatable {
  const MedicineScanState();

  @override
  List<Object> get props => [];
}

class MedicineScanInitial extends MedicineScanState {
  const MedicineScanInitial();
}

class MedicineScanLoading extends MedicineScanState {
  const MedicineScanLoading();
}

class MedicineScanSuccess extends MedicineScanState {
  final String message;
  final XFile image;

  const MedicineScanSuccess(this.message, this.image);

  @override
  List<Object> get props => [message];
}

class MedicineScanFailure extends MedicineScanState {
  final String message;

  const MedicineScanFailure(this.message);

  @override
  List<Object> get props => [message];
}


class ScanResult extends MedicineScanState {
  final List<Medicine> medicines;

  const ScanResult(this.medicines);

  @override
  List<Object> get props => [medicines];
}