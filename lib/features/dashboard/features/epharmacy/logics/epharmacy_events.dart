import 'package:equatable/equatable.dart';

abstract class EpharmacyEvents extends Equatable {
  const EpharmacyEvents();

  @override
  List<Object> get props => [];
}

class EpharmacyRefreshEvent extends EpharmacyEvents {
  const EpharmacyRefreshEvent();

  @override
  List<Object> get props => [];
}



class EpharmacyLoadMoreEvent extends EpharmacyEvents {
  final int page;

  const EpharmacyLoadMoreEvent(this.page);

  @override
  List<Object> get props => [page];
}