import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/shared_repository.dart';
import 'package:meditouch/features/dashboard/features/cart/data/cart_repository.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_state.dart';

import '../data/model/medicine_details_model.dart';
import '../data/repository/detailed_medicine_repository.dart';
import 'detailed_medicine_event.dart';

class DetailedMedicineBloc
    extends Bloc<DetailedMedicineEvent, DetailedMedicineState> {
  DetailedMedicineBloc() : super(DetailedMedicineInitial()) {
    // fetch detailed medicine
    on<FetchDetailedMedicineEvent>(_fetchDetailedMedicine);

    // change unit of the medicine
    on<ChangeUnitRequested>(_changeUnitRequested);

    // add to cart
    on<AddToCartRequested>(_addToCartRequested);

    // reset the add to cart state
    on<ResetAddToCart>(resetAddToCart);
  }

  Future<void> _fetchDetailedMedicine(FetchDetailedMedicineEvent event,
      Emitter<DetailedMedicineState> emit) async {
    emit(DetailedMedicineLoading());

    // get the build id
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

  // Change the unit of the medicine
  void _changeUnitRequested(
      ChangeUnitRequested event, Emitter<DetailedMedicineState> emit) {
    if (state is DetailedMedicineSuccess) {
      final DetailedMedicineSuccess currentState =
          state as DetailedMedicineSuccess;
      emit(DetailedMedicineSuccess(currentState.medicineDetails, event.index));
    }
  }

  // Add to cart
  Future<void> _addToCartRequested(
      AddToCartRequested event, Emitter<DetailedMedicineState> emit) async {
    // initial state
    emit(DetailedMedicineLoading());

    // process the request to server
    final Map<String, dynamic> response =
        await CartRepository().addToCart(event.cartModel);

    if (response['status']) {
      emit(AddToCartSuccess(response['message']));
    } else {
      emit(CartAddError(response['message']));
    }
  }

  void resetAddToCart(
      ResetAddToCart event, Emitter<DetailedMedicineState> emit) {
    emit(DetailedMedicineInitial());
  }
}
