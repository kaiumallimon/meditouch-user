import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/features/auth/login/data/repository/login_repository.dart';
import 'package:meditouch/features/auth/login/logic/login_event.dart';
import 'package:meditouch/features/auth/login/logic/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitialState()) {
    on<LoginSubmitted>(_loginSubmitted);
  }

  Future<void> _loginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    // Initially show the loading state
    emit(LoginLoadingState());

    // Check if email or password is empty
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(LoginErrorState('Both email and password are required to login!'));
      return;
    }

    // Process the login
    final response = await loginRepository.login(event.email, event.password);

    // Handle repository response
    if (response.containsKey('status') && response['status'] == 'success') {
      final userInfo = response['user'];

      // Save user info to Hive
      await HiveRepository().saveUserInfo(
        userInfo['id'],
        userInfo['name'],
        userInfo['email'],
        userInfo['gender'],
        userInfo['dob'],
        userInfo['image'],
        userInfo['phone'],
      );

      emit(LoginSuccessState(response['message']));
    } else {
      // Handle error message
      final errorMessage = response.containsKey('error')
          ? response['error']
          : 'An unknown error occurred.';
      emit(LoginErrorState(errorMessage));
    }
  }
}
