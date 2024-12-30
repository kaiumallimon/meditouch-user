import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/shared_repository.dart';
import 'package:meditouch/common/utils/epharmacy_util.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_state.dart';

import '../data/model/medicine_details_model.dart';
import '../data/repository/detailed_medicine_repository.dart';
import 'detailed_medicine_event.dart';

class DetailedMedicineBloc
    extends Bloc<DetailedMedicineEvent, DetailedMedicineState> {
  DetailedMedicineBloc() : super(DetailedMedicineInitial()) {
    on<FetchDetailedMedicineEvent>(_fetchDetailedMedicine);
    on<ChangeUnitRequested>(_changeUnitRequested);
  }

  Future<void> _fetchDetailedMedicine(FetchDetailedMedicineEvent event,
      Emitter<DetailedMedicineState> emit) async {
    emit(DetailedMedicineLoading());

    // generate the url for the request

    /*
    https://medeasy.health/_next/data/WzarUBZ0M7ekq86WXo6ov/en/medicines/Sergel-20-mg-Capsule.json?slug=Sergel-20-mg-Capsule
     */

    String buildId = await SharedRepository().getBuildId();

    final String url =
        "https://medeasy.health/_next/data/$buildId/en/medicines/${event.slug}.json?slug=${event.slug}";

    // request data from the server
    final MedicineDetailsModel? medicineDetails =
        await DetailedMedicineRepository().getMedicineDetails(url);
    if (medicineDetails != null) {
      emit(DetailedMedicineSuccess(medicineDetails, 0));
    } else {
      emit(const DetailedMedicineError('Error occurred'));
    }
  }

  void _changeUnitRequested(
      ChangeUnitRequested event, Emitter<DetailedMedicineState> emit) {
    if (state is DetailedMedicineSuccess) {
      final DetailedMedicineSuccess currentState =
          state as DetailedMedicineSuccess;
      emit(DetailedMedicineSuccess(currentState.medicineDetails, event.index));
    }
  }
}
