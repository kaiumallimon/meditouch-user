import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> data;
  final String uid;
  final XFile? image;

  UpdateProfile({required this.data, required this.uid, this.image}) {
    print('UpdateProfile');
    print('data: $data');
  }

  @override
  List<Object> get props => [data, uid];
}

class ProfileEdit extends ProfileEvent {
  const ProfileEdit();

  @override
  List<Object> get props => [];
}

class ProfileEditDone extends ProfileEvent {
  const ProfileEditDone();

  @override
  List<Object> get props => [];
}
