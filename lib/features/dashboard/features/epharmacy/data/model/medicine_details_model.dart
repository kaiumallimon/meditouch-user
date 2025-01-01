import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';

class MedicineDetailsModel extends Equatable {
  final int medicineId;
  final List<UnitPriceDetailed> unitPrices;
  final String title;
  final String metaDescription;
  final String medicineName;
  final String categoryName;
  final String slug;
  final String strength;
  final String genericName;
  final String manufacturerName;
  final String medicineImage;
  final String? description;
  final String discountType;
  final double discountValue;
  final bool isAvailable;
  final int orderCount;
  final int medicineCategoryId;
  final int manufacturerId;
  final MedicineDescription medicineDetails;
  final List<Medicine> relatedMedicines;
  final bool rxRequired;

  const MedicineDetailsModel({
    required this.medicineId,
    required this.unitPrices,
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
    required this.relatedMedicines,
    this.rxRequired = false,
  });

  factory MedicineDetailsModel.fromJson(Map<String, dynamic> json) {
    // Safe access to 'pageProps' and 'productInfo'
    var pageProps = json['pageProps'];
    if (pageProps == null || pageProps['productInfo'] == null) {
      throw Exception(
          'Missing required data: productInfo or pageProps is null');
    }

    var unitPricesFromJson =
        pageProps['productInfo']['unit_prices'] as List? ?? [];
    List<UnitPriceDetailed> unitPricesList = unitPricesFromJson
        .map((unitPriceJson) => UnitPriceDetailed.fromJson(unitPriceJson))
        .toList();

    var relatedMedicinesFromJson =
        pageProps['productDetails']?['related_medicines'] as List? ?? [];
    List<Medicine> relatedMedicinesList = relatedMedicinesFromJson
        .map((relatedMedicineJson) => Medicine.fromJson(relatedMedicineJson))
        .toList();

    return MedicineDetailsModel(
      medicineId: pageProps['productInfo']['id'],
      unitPrices: unitPricesList,
      title: pageProps['productInfo']['title'],
      metaDescription: pageProps['productInfo']['meta_description'],
      medicineName: pageProps['productInfo']['medicine_name'],
      categoryName: pageProps['productInfo']['category_name'],
      slug: pageProps['productInfo']['slug'],
      strength: pageProps['productInfo']['strength'],
      genericName: pageProps['productInfo']['generic_name'],
      manufacturerName: pageProps['productInfo']['manufacturer_name'],
      medicineImage: pageProps['productInfo']['medicine_image'],
      description: pageProps['productInfo']['description'],
      discountType: pageProps['productInfo']['discount_type'],
      discountValue:
          pageProps['productInfo']['discount_value']?.toDouble() ?? 0.0,
      isAvailable: pageProps['productInfo']['is_available'],
      orderCount: pageProps['productInfo']['order_count'],
      medicineCategoryId: pageProps['productInfo']['medicine_category'],
      manufacturerId: pageProps['productInfo']['manufacturer'],
      medicineDetails:
          MedicineDescription.fromJson(pageProps['productDetails'] ?? {}),
      relatedMedicines: relatedMedicinesList,
      rxRequired: pageProps['productInfo']['rx_required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> unitPricesToJson =
        unitPrices.map((unitPrice) => unitPrice.toJson()).toList();

    List<Map<String, dynamic>> relatedMedicinesToJson = relatedMedicines
        .map((relatedMedicine) => relatedMedicine.toJson())
        .toList();

    return {
      'pageProps': {
        'productInfo': {
          'id': medicineId,
          'unit_prices': unitPricesToJson,
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
          'medicine_category': medicineCategoryId,
          'manufacturer': manufacturerId,
          'rx_required': rxRequired,
        },
        'productDetails': medicineDetails.toJson(),
      },
      'related_medicines': relatedMedicinesToJson,
    };
  }

  @override
  List<Object?> get props => [
        medicineId,
        unitPrices,
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
        relatedMedicines,
        rxRequired,
      ];
}

class MedicineDescription extends Equatable {
  final String status;
  final Map<String, dynamic> medicineDetails;

  const MedicineDescription(
      {required this.status, required this.medicineDetails});

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

class UnitPriceDetailed extends Equatable {
  final String unit;
  final int unitSize;
  final String price;

  const UnitPriceDetailed({
    required this.unit,
    required this.unitSize,
    required this.price,
  });

  factory UnitPriceDetailed.fromJson(Map<String, dynamic> json) {
    return UnitPriceDetailed(
      unit: json['unit'],
      unitSize: json['unit_size'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'unit_size': unitSize,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [unit, unitSize, price];
}
