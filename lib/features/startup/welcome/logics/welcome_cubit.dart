import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeCubit extends Cubit<int> {
  WelcomeCubit() : super(0);

  void next() {
    emit(state + 1);
  }
}
