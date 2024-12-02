import 'package:bloc/bloc.dart';

class GenderCubit extends Cubit<String?> {
  GenderCubit() : super(null); // Initial state is null

  void selectGender(String gender) {
    emit(gender);
  }
}
