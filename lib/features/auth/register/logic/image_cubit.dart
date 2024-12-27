import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<XFile?> {
  ImagePickerCubit() : super(null);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      emit(image); // Update the state with the picked image
    }
  }

  void reset() => emit(null); // Reset state to null
}
