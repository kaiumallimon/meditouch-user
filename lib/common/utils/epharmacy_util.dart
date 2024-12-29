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

String getDetailedPageUrl(
    String id, String genericName, String categoryName, String strength) {
  var formattedGenericName = genericName.replaceAll(' ', '%20');
  var formattedCategoryName = categoryName.replaceAll(' ', '%20');
  var formattedStrength = strength.replaceAll(' ', '%20');
  String baseUrl =
      "https://api.medeasy.health/api/patient/medicine-details/?generic_name=$formattedGenericName&category_name=$formattedCategoryName&id=${id.toString()}&strength=$formattedStrength&lang=en";
  return baseUrl;
}
