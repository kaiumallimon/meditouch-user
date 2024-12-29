import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

class MedicineDetailsModel extends Equatable {
  final String medicineId;
  final UnitPrice unitPrice;
  final String title;
  final String metaDescription;
  final String medicineName;
  final String categoryName;
  final String slug;
  final String strength;
  final String genericName;
  final String manufacturerName;
  final String medicineImage;
  final String description;
  final String discountType;
  final double discountValue;
  final bool isAvailable;
  final int orderCount;
  final int medicineCategoryId;
  final int manufacturerId;
  final MedicineDescription medicineDetails;

  const MedicineDetailsModel({
    required this.medicineId,
    required this.unitPrice,
    required this.title,
    required this.metaDescription,
    required this.medicineName,
    required this.categoryName,
    required this.slug,
    required this.strength,
    required this.genericName,
    required this.manufacturerName,
    required this.medicineImage,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.isAvailable,
    required this.orderCount,
    required this.medicineCategoryId,
    required this.manufacturerId,
    required this.medicineDetails,
  });

  factory MedicineDetailsModel.fromJson(Map<String, dynamic> json) {
    return MedicineDetailsModel(
      medicineId: json['medicine_id'],
      unitPrice: UnitPrice.fromJson(json['unit_price']),
      title: json['title'],
      metaDescription: json['meta_description'],
      medicineName: json['medicine_name'],
      categoryName: json['category_name'],
      slug: json['slug'],
      strength: json['strength'],
      genericName: json['generic_name'],
      manufacturerName: json['manufacturer_name'],
      medicineImage: json['medicine_image'],
      description: json['description'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'].toDouble(),
      isAvailable: json['is_available'],
      orderCount: json['order_count'],
      medicineCategoryId: json['medicine_category_id'],
      manufacturerId: json['manufacturer_id'],
      medicineDetails: MedicineDescription.fromJson(json['medicine_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'unit_price': unitPrice.toJson(),
      'title': title,
      'meta_description': metaDescription,
      'medicine_name': medicineName,
      'category_name': categoryName,
      'slug': slug,
      'strength': strength,
      'generic_name': genericName,
      'manufacturer_name': manufacturerName,
      'medicine_image': medicineImage,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'is_available': isAvailable,
      'order_count': orderCount,
      'medicine_category_id': medicineCategoryId,
      'manufacturer_id': manufacturerId,
      'medicine_details': medicineDetails.toJson(),
    };
  }

  @override
  List<Object> get props => [
        medicineId,
        unitPrice,
        title,
        metaDescription,
        medicineName,
        categoryName,
        slug,
        strength,
        genericName,
        manufacturerName,
        medicineImage,
        description,
        discountType,
        discountValue,
        isAvailable,
        orderCount,
        medicineCategoryId,
        manufacturerId,
        medicineDetails,
      ];
}

class MedicineDescription extends Equatable {
  final String status;
  final Map<String, String> medicineDetails;

  const MedicineDescription({required this.status, required this.medicineDetails});

  factory MedicineDescription.fromJson(Map<String, dynamic> json) {
    return MedicineDescription(
      status: json['status'],
      medicineDetails: json['medicine_details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'medicine_details': medicineDetails,
    };
  }

  @override
  List<Object> get props => [status, medicineDetails];
}
