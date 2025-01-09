import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/repository/gemini_repository.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/medicine_scan_state.dart';
import '../data/repository/epharmacy_search_repository.dart';
import 'medicine_scan_event.dart';

class MedicineScanBloc extends Bloc<MedicineScanEvent, MedicineScanState> {
  final ImagePicker _picker = ImagePicker();

  MedicineScanBloc() : super(const MedicineScanInitial()) {
    on<ScanMedicineRequested>((event, emit) async {
      emit(const MedicineScanLoading());

      try {
        // Request to open the camera and capture image
        XFile? image = await _picker.pickImage(source: ImageSource.camera);

        if (image != null) {
          emit(MedicineScanSuccess(image.path, image));
        } else {
          emit(const MedicineScanFailure("No image captured"));
        }
      } catch (e) {
        emit(MedicineScanFailure("Error capturing image: $e"));
      }
    });

    on<ChooseFromGalleryRequested>((event, emit) async {
      emit(const MedicineScanLoading());

      try {
        // Request to open the gallery and select image
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          emit(MedicineScanSuccess(image.path, image));
        } else {
          emit(const MedicineScanFailure("No image selected"));
        }
      } catch (e) {
        emit(MedicineScanFailure("Error selecting image: $e"));
      }
    });

    on<SendGeminiRequested>((event, emit) async {
      emit(const MedicineScanLoading());

      try {
        final image = event.image;

        final response =
            await GeminiRepository().analyzeMedicineImage(File(image.path));

        if (!response['status']) {
          emit(MedicineScanFailure(response['message']));
          return;
        }

        final medicineResponse =
            await EpharmacySearchRepository().searchMedicine(
          response['response']['name'],
        );

        if (medicineResponse == null) {
          emit(const MedicineScanFailure("No medicine found"));
          return;
        }

        emit(ScanResult(medicineResponse));

        // emit(ScanResult(response['data']));
      } catch (e) {
        emit(MedicineScanFailure("Error sending image to Gemini: $e"));
      }
    });

    on<ResetMedicineScan>((event, emit) {
      emit(const MedicineScanInitial());
    });
  }
}
