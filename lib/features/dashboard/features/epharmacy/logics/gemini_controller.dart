import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GeminiController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Reactive variable to store the picked image
  var selectedImagePath = ''.obs;

  // Function to pick image from gallery
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }

  // Function to take a photo using the camera
  Future<void> captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImagePath.value = image.path;
    } else {
      Get.snackbar("Error", "No image captured");
    }
  }
}
