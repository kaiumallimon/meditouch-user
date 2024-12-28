import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditouch/common/repository/hive_repository.dart';
import 'package:meditouch/features/dashboard/features/profile/data/repository/profile_repository.dart';
import 'package:meditouch/features/dashboard/features/profile/logics/profile_state.dart';

import 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({
    required this.profileRepository,
  }) : super(ProfileInitial()) {
    // Listen to the update profile event
    on<UpdateProfile>((event, emit) async {
      // Emit the loading state
      emit(ProfileLoading());

      // Get old data from the Hive repository
      final oldData = await HiveRepository().getUserInfo();

      // Call the API to update the profile
      final response = await profileRepository.update(
        event.uid,
        event.data,
        oldData!,
        event.image,
      );

      // Check if the response is successful
      if (response.containsKey('status') && response['status']) {
        try {
          // Update the Hive repository with the new data from the API response
          final updatedData = response['data'] as Map<String, dynamic>;

          // Ensure the updated data is not null or empty
          if (updatedData.isNotEmpty) {
            await HiveRepository().updateUserInfo(updatedData);
          }

          emit(ProfileUpdated(message: response['message']));
        } on Exception catch (e) {
          emit(ProfileUpdateError(message: e.toString()));
        }
      } else {
        emit(ProfileUpdateError(message: response['message']));
      }
    });

    // Listen to the edit profile event
    on<ProfileEdit>((event, emit) async {
      emit(const ProfileEditState());
    });

    // Listen to the edit done event
    on<ProfileEditDone>((event, emit) async {
      emit(const ProfileEditDoneState());
    });
  }
}
