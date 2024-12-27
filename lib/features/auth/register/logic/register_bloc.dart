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
    // Show loading state
    emit(RegisterLoadingState());

    // Check for empty fields
    if (event.name.isEmpty ||
        event.phone.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty ||
        event.dob == null || // Ensure dob is not null
        event.gender == null) {
      // Ensure gender is not null
      emit(RegisterErrorState('Please fill all the fields'));
      return;
    }

    // Check if password and confirmPassword match
    if (event.password != event.confirmPassword) {
      emit(RegisterErrorState('Password does not match'));
      return;
    }

    // Check if the email is valid
    if (!await EmailVerifier().verify(event.email)) {
      emit(RegisterErrorState('Please enter a valid email'));
      return;
    }

    // Proceed to registration
    final response = await RegistrationRepository().register(
      event.name,
      event.phone,
      event.email,
      event.gender!, // Non-nullable, force unwrap after null check
      event.dob!, // Non-nullable, force unwrap after null check
      event.password,
      event.image,
    );

    // Handle registration success or error
    if (response.containsKey('status') && response['status'] == 'success') {
      emit(RegisterSuccessState(response['message']));
    } else {
      emit(RegisterErrorState(response['message']));
    }
  }
}
