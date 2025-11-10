import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/utils/api_service.dart';


class DashboardController extends GetxController {
  TextEditingController nationalCodeSearchController = TextEditingController();
  RxString nationalCodeSearch = ''.obs;
  var patients = <Patient>[].obs;
  var patient = Rxn<Patient>(); // Rxn means nullable reactive variable
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nationalCodeSearchController.addListener(
      () {
        
        nationalCodeSearch.value = nationalCodeSearchController.text;
      }
    );
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

  Future<void> searchPatient(String nationalCode) async {
    isLoading.value = true;
    error.value = '';
    patient.value = null;

    try {
      final result = await ApiService().searchPatient(nationalCode.trim());
      patient.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}