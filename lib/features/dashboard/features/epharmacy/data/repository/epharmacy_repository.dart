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
}
