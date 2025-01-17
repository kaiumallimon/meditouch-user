import 'medicine_model.dart';

class CombinedMedicine {
  final String prescriptionName;
  final String prescriptionStrength;
  final Medicine searchResult;

  CombinedMedicine({
    required this.prescriptionName,
    required this.prescriptionStrength,
    required this.searchResult,
  });
}