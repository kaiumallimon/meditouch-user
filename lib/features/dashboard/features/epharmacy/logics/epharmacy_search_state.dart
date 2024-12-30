import 'package:equatable/equatable.dart';

import '../data/model/medicine_model.dart';

abstract class EpharmacySearchState extends Equatable{
  const EpharmacySearchState();

  @override
  List<Object> get props => [];
}

class EpharmacySearchInitial extends EpharmacySearchState {}

class EpharmacySearchLoading extends EpharmacySearchState {}

class EpharmacySearchSuccess extends EpharmacySearchState {
  final List<Medicine> medicines;
  final String query;

  const EpharmacySearchSuccess({required this.medicines, required this.query}); 

  @override
  List<Object> get props => [medicines];
}

class EpharmacySearchError extends EpharmacySearchState {
  final String message;
  final String query;

  const EpharmacySearchError({required this.message, required this.query});

  @override
  List<Object> get props => [message, query];
}
