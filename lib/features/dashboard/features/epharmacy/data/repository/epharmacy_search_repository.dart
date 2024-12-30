import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/medicine_model.dart';

class EpharmacySearchRepository {
  Future<List<Medicine>?> searchMedicine(String query) async {
    try {
      final String url =
          'https://api.medeasy.health/api/patient/search-medicines/?q=$query&from=0&to=10';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final medicinesJson = jsonDecode(response.body)['medicines'] as List;
        return medicinesJson
            .map((medicineJson) => Medicine.fromJson(medicineJson))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
