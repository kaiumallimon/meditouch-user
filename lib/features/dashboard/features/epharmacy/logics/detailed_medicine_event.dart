import 'package:equatable/equatable.dart';

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