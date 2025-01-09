import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class MedicineScanEvent extends Equatable {
  const MedicineScanEvent();

  @override
  List<Object> get props => [];
}

class ScanMedicineRequested extends MedicineScanEvent {
  const ScanMedicineRequested();
}

class ChooseFromGalleryRequested extends MedicineScanEvent {
  const ChooseFromGalleryRequested();
}

class SendGeminiRequested extends MedicineScanEvent {
  final XFile image;
  const SendGeminiRequested(this.image);
}


class ResetMedicineScan extends MedicineScanEvent {
  const ResetMedicineScan();
}