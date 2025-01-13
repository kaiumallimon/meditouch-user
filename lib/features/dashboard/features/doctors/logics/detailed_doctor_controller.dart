import 'package:get/get.dart';
import 'package:meditouch/features/dashboard/features/doctors/data/repository/detailed_doctor_repository.dart';

class DetailedDoctorController extends GetxController {
  final DetailedDoctorRepository repository;

  final String doctorId;

  // Constructor with dependency injection for the repository
  DetailedDoctorController(this.doctorId, {required this.repository});

  // Observable loading state
  var isLoading = false.obs;

  // Observable timeSlots map
  var timeSlots = <String, List<Map<String, dynamic>>>{}.obs;

  var errorMessage = ''.obs;

  /// Set the loading state
  void setLoading(bool value) {
    isLoading.value = value;
  }

  /// Fetch appointment slots for a specific doctor
  Future<void> fetchAppointmentSlots() async {
    setLoading(true);

    try {
      // Fetch appointments from the repository
      final result = await repository.fetchAppointmentSlots(doctorId);

      // Update the timeSlots with sorted and processed data
      timeSlots.value = result;
    } catch (e) {
      // Handle error by showing a snackbar or logging
      errorMessage.value = 'Error fetching appointment slots: $e';
    } finally {
      // Ensure loading state is updated in all cases
      setLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAppointmentSlots();
  }
}
