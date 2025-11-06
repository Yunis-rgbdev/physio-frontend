import 'package:get/get.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/utils/api_service.dart';


class DashboardController extends GetxController {
  var patients = <Patient>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
  try {
    isLoading(true);
    final response = await ApiService.getPatients(); // Returns List
    
    patients.value = List<Patient>.from(
      response.map((json) => Patient.fromJson(json as Map<String, dynamic>))
    );
  } catch (e) {
    print('Error fetching patients: $e');
  } finally {
    isLoading(false);
  }
}
}