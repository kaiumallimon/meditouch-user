import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/features/auth/login/data/repository/login_repository.dart';
import 'package:meditouch/features/auth/login/logic/login_event.dart';
import 'package:meditouch/features/auth/login/logic/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmitted>(_loginSubmitted);
  }

  Future<void> _loginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    // initially show the loading state
    emit(LoginLoadingState());


    // check email or password if they are empty
    if(event.email.isEmpty || event.password.isEmpty){
      emit(LoginErrorState('Both email and password are required to login!'));
      return;
    }


    // process the login
    final response = await LoginRepository().login(event.email, event.password);

    // error/success state
    if (response.containsKey('status') && response['status'] == 'success') {
      final userInfo = response['user'];

      await HiveRepository().saveUserInfo(
          userInfo['_id'],
          userInfo['name'],
          userInfo['email'],
          userInfo['gender'],
          userInfo['dob'],
          userInfo['image']);
      emit(LoginSuccessState(response['message']));
      return;
    }


    emit(LoginErrorState(response['message']));

  }
}
