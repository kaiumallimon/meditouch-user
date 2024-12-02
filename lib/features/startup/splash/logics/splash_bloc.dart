import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashStartedEvent>(_onStartSplash);
  }

  Future _onStartSplash(
      SplashStartedEvent event, Emitter<SplashState> emit) async {
    // on loading state
    emit(SplashLoadingState());
    // hold the state for 2 seconds
    Future.delayed(const Duration(seconds: 2));
    // mark as loading Complete
    emit(SplashLoadedState());
  }
}
