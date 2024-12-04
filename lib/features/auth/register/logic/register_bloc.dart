import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch/features/auth/register/data/repository/email_verifier.dart';
import 'package:meditouch/features/auth/register/data/repository/registration_repository.dart';
import 'package:meditouch/features/auth/register/logic/register_state.dart';
part './register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterSubmitted>(_registerSubmitted);
  }

  Future<void> _registerSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    // show loading state
    emit(RegisterLoadingState());

    // do the registration in background

    if(event.name.isEmpty || event.phone.isEmpty || event.email.isEmpty || event.dob==null || event.gender==null || event.password.isEmpty || event.confirmPassword.isEmpty){
      emit(RegisterErrorState('Please fill all the fields'));
      return;
    }

    if(event.password != event.confirmPassword){
      emit(RegisterErrorState('Password does not matches'));
      return;

    }

    if(!await EmailVerifier().verify(event.email)){
      emit(RegisterErrorState('Please enter a valid email'));
      return;
    }


    // checks are complete now process to the registration
    // get the response
    final response = await RegistrationRepository().register(event.name,event. phone, event.email, event.gender!, event.dob!, event.password, event.image);

    // mark as done with/without errors

    if(response.containsKey('status')){
      emit(RegisterSuccessState(response['message']));
    }else{
      emit(RegisterErrorState(response['message']));
    }
  }
}
