import 'dart:developer';

import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailedMedicineRepository {
  Future<MedicineDetailsModel?> getMedicineDetails(String url) async {
    print('URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        log('Medicine Details: $json');
        return MedicineDetailsModel.fromJson(json);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
