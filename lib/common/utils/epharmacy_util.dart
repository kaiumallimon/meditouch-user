import '../../features/dashboard/features/epharmacy/logics/epharmacy_states.dart';

String getImageUrl(String url) => "https://api.medeasy.health$url";

double getUnitPrice(medicine) {
  return medicine.unitPrices.isNotEmpty ? medicine.unitPrices.first.price : 0.0;
}

String getUnit(medicine) {
  return medicine.unitPrices.isNotEmpty ? medicine.unitPrices.first.unit : '';
}

double getDiscountedPrice(double unitPrice, medicine) {
  return unitPrice - (unitPrice * (medicine.discountValue / 100));
}

int getNextPage(EpharmacySuccessState state) {
  return (state.medicines.length ~/ 20) + 1;
}
