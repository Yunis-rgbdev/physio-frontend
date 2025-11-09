import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/utils/api_service.dart';


class DashboardController extends GetxController {
  TextEditingController nationalCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController FullNameController = TextEditingController();
  TextEditingController GenderController = TextEditingController();
  TextEditingController BirthDateController = TextEditingController();
  TextEditingController WeightController = TextEditingController();
  TextEditingController HeightController = TextEditingController();
  TextEditingController ReasonController = TextEditingController();
  TextEditingController EducationController = TextEditingController();
  TextEditingController MarriageController = TextEditingController();
  TextEditingController ChildrenCountController = TextEditingController();
  TextEditingController DoctorNameController = TextEditingController();
  TextEditingController TherapistNameController = TextEditingController();
  TextEditingController AppointmentDateController = TextEditingController();
  TextEditingController RelationshipController = TextEditingController();
  TextEditingController HelperToolController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  RxString nationalCode = ''.obs;
  RxString fullName = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;
  RxString Weight = ''.obs;
  RxString height= ''.obs;
  RxString reason = ''.obs;
  RxString education = ''.obs;
  RxString relationshipStatus = ''.obs;
  RxString childrenCount = ''.obs;
  RxString doctorName = ''.obs;
  RxString therapistName = ''.obs;
  RxString appointmentDate = ''.obs;
  RxString helperTool = ''.obs;
  RxString address = ''.obs;

  var patients = <Patient>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    
    fetchPatients();
    super.onInit();
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    FullNameController.addListener(
      () {  
        fullName.value = FullNameController.text;
      }
    );
    GenderController.addListener(
      () {  
        gender.value = GenderController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
    nationalCodeController.addListener(
      () {  
        nationalCode.value = nationalCodeController.text;
      }
    );
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