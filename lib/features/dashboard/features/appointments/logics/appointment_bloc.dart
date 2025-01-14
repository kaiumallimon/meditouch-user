import 'package:flutter_bloc/flutter_bloc.dart';


class AppointmentCubit extends Cubit<String>{
  AppointmentCubit() : super('upcoming');

  void changeTab(String tab) => emit(tab);
}