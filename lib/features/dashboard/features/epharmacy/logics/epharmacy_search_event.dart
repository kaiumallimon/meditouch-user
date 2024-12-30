import 'package:equatable/equatable.dart';

abstract class EpharmacySearchEvent extends Equatable{
  const EpharmacySearchEvent();

  @override
  List<Object> get props => [];
}

class EpharmacySearchQueryEvent extends EpharmacySearchEvent {
  final String query;

  const EpharmacySearchQueryEvent({required this.query});

  @override
  List<Object> get props => [query];
}


class EpharmacySearchClearEvent extends EpharmacySearchEvent {
  const EpharmacySearchClearEvent();
}

