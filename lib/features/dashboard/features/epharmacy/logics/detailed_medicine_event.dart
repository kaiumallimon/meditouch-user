import 'package:equatable/equatable.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';

abstract class DetailedMedicineEvent extends Equatable {
  const DetailedMedicineEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailedMedicineEvent extends DetailedMedicineEvent {
  final String slug;

  const FetchDetailedMedicineEvent(this.slug);

  @override
  List<Object> get props => [];
}

class ChangeUnitRequested extends DetailedMedicineEvent {
  final int index;

  const ChangeUnitRequested(this.index);

  @override
  List<Object> get props => [index];
}

class AddToCartRequested extends DetailedMedicineEvent {
  final CartModel cartModel;

  const AddToCartRequested(this.cartModel);
}


class ResetAddToCart extends DetailedMedicineEvent {
  const ResetAddToCart();

  @override
  List<Object> get props => [];
}