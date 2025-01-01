import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

class FavouriteModel {
  final String userId;
  final Medicine medicine;
  final String favouriteId;

  FavouriteModel({
    required this.userId,
    required this.medicine,
    required this.favouriteId,
  });

  factory FavouriteModel.fromJson(
      Map<String, dynamic> json, String favouriteId) {
    return FavouriteModel(
      favouriteId: favouriteId,
      userId: json['user_id'],
      medicine: Medicine.fromJson(json['medicine']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'medicine': medicine.toJson(),
    };
  }
}
