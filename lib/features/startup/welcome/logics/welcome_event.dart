part of 'welcome_bloc.dart';

abstract class WelcomeEvent extends Equatable {
  const WelcomeEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePage extends WelcomeEvent {
  final int pageIndex;

  const UpdatePage(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
