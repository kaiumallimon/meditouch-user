import 'package:equatable/equatable.dart';

abstract class EpharmacyEvents extends Equatable {
  const EpharmacyEvents();

  @override
  List<Object> get props => [];
}

class EpharmacyRefreshEvent extends EpharmacyEvents {
  const EpharmacyRefreshEvent({
    required this.currentPage,
  }) : super();

  final int currentPage;

  @override
  List<Object> get props => [currentPage];
}
