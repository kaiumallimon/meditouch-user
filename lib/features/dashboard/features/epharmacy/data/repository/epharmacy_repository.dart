import 'package:http/http.dart' as http;
import 'dart:convert';
import './../model/medicine_model.dart';

class EpharmacyRepository {
  Future<MedicinesResponse?> getMedicines(String buildId, int page) async {
    // final String baseUrl = dotenv.env['BASE_URL']!;
    final String url =
        "https://medeasy.health/_next/data/$buildId/en/category/otc-medicine.json?page=$page&slug=otc-medicine";

    final Uri uri = Uri.parse(url);

    print("Current page: $page");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // Decode the response body
        final data = jsonDecode(response.body);

        // Get totalPages and products from the response
        final totalPages =
            data['pageProps']['pagination']['total_pages'] as int;
        final products = data['pageProps']['products'] as List;

        // Return a MedicinesResponse object containing both medicines and totalPages
        return MedicinesResponse(
          medicines: products
              .map((medicineJson) => Medicine.fromJson(medicineJson))
              .toList(),
          totalPages: totalPages,
        );
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }


  Future<List<Medicine>?> searchMedicineForAutomaticOrder(String query) async {
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
        // Return an empty list if the status is not 200
        return [];
      }
    } catch (e) {
      print('Error: $e');
      // Return an empty list in case of an error
      return [];
    }
  }
}
