part of 'welcome_bloc.dart';

abstract class WelcomeState extends Equatable {
  const WelcomeState();

  @override
  List<Object?> get props => [];
}

class WelcomeInitial extends WelcomeState {
  final int pageIndex;

  const WelcomeInitial(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
