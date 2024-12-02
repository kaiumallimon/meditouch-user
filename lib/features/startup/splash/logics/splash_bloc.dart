import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashStartedEvent>(_onStartSplash);
  }

  Future<void> _onStartSplash(
      SplashStartedEvent event, Emitter<SplashState> emit) async {
    // Emit loading state when splash starts
    emit(SplashLoadingState());

    // Hold the state for 2 seconds and wait for the delay
    await Future.delayed(const Duration(seconds: 2));

    // Mark as loading complete
    emit(SplashLoadedState());
  }
}
