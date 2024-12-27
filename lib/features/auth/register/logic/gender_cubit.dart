import 'package:flutter_bloc/flutter_bloc.dart';

class GenderCubit extends Cubit<String?> {
  GenderCubit() : super(null); // Initial state is null

  void selectGender(String gender) {
    emit(gender);
  }

  void reset() => emit(null); // Reset state to null
}
