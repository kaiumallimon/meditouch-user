import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final int id;
  final String medicineName;
  final String categoryName;
  final String slug;
  final String genericName;
  final String strength;
  final String manufacturerName;
  final String discountType;
  final double discountValue;
  final bool isDiscountable;
  final bool isAvailable;
  final String medicineImage;
  final bool rxRequired;
  final List<UnitPrice> unitPrices;

  const Medicine({
    required this.id,
    required this.medicineName,
    required this.categoryName,
    required this.slug,
    required this.genericName,
    required this.strength,
    required this.manufacturerName,
    required this.discountType,
    required this.discountValue,
    required this.isDiscountable,
    required this.isAvailable,
    required this.medicineImage,
    required this.rxRequired,
    required this.unitPrices,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    var unitPricesFromJson = json['unit_prices'] as List;
    List<UnitPrice> unitPricesList = unitPricesFromJson
        .map((unitPriceJson) => UnitPrice.fromJson(unitPriceJson))
        .toList();

    return Medicine(
      id: json['id'],
      medicineName: json['medicine_name'],
      categoryName: json['category_name'],
      slug: json['slug'],
      genericName: json['generic_name'],
      strength: json['strength'],
      manufacturerName: json['manufacturer_name'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'].toDouble(),
      isDiscountable: json['is_discountable'],
      isAvailable: json['is_available'],
      medicineImage: json['medicine_image'],
      rxRequired: json['rx_required'],
      unitPrices: unitPricesList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> unitPricesToJson =
        unitPrices.map((unitPrice) => unitPrice.toJson()).toList();

    return {
      'id': id,
      'medicine_name': medicineName,
      'category_name': categoryName,
      'slug': slug,
      'generic_name': genericName,
      'strength': strength,
      'manufacturer_name': manufacturerName,
      'discount_type': discountType,
      'discount_value': discountValue,
      'is_discountable': isDiscountable,
      'is_available': isAvailable,
      'medicine_image': medicineImage,
      'rx_required': rxRequired,
      'unit_prices': unitPricesToJson,
    };
  }

  @override
  List<Object?> get props => [
        id,
        medicineName,
        categoryName,
        slug,
        genericName,
        strength,
        manufacturerName,
        discountType,
        discountValue,
        isDiscountable,
        isAvailable,
        medicineImage,
        rxRequired,
        unitPrices,
      ];


  // default model
  // default model
  Medicine.defaultMedicine()
      : id = 0,
        medicineName = '',
        categoryName = '',
        slug = '',
        genericName = '',
        strength = '',
        manufacturerName = '',
        discountType = '',
        discountValue = 0.0,
        isDiscountable = false,
        isAvailable = false,
        medicineImage = '',
        rxRequired = false,
        unitPrices = [];

}

class UnitPrice extends Equatable {
  final String unit;
  final int unitSize;
  final double price;

  const UnitPrice({
    required this.unit,
    required this.unitSize,
    required this.price,
  });

  factory UnitPrice.fromJson(Map<String, dynamic> json) {
    return UnitPrice(
      unit: json['unit'],
      unitSize: json['unit_size'],
      price: json['price'].toDouble(),
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


class MedicinesResponse  extends Equatable {
  final List<Medicine> medicines;
  final int totalPages;

  const MedicinesResponse({
    required this.medicines,
    required this.totalPages,
  });

  factory MedicinesResponse.fromJson(Map<String, dynamic> json) {
    var medicinesFromJson = json['medicines'] as List;
    List<Medicine> medicinesList =
        medicinesFromJson.map((medicineJson) => Medicine.fromJson(medicineJson)).toList();

    return MedicinesResponse(
      medicines: medicinesList,
      totalPages: json['total_pages'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> medicinesToJson =
        medicines.map((medicine) => medicine.toJson()).toList();

    return {
      'medicines': medicinesToJson,
      'total_pages': totalPages,
    };
  }

  @override
  List<Object?> get props => [medicines, totalPages];
}