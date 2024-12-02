import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part './welcome_event.dart';
part './welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(const WelcomeInitial(0)) {
    on<UpdatePage>((event, emit) {
      emit(WelcomeInitial(event.pageIndex));
    });
  }
}
