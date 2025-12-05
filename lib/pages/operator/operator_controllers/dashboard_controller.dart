import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telewehab/models/patient_models.dart';
import 'package:telewehab/models/medical_file_model.dart';
import 'package:telewehab/utils/api_service.dart';
import 'package:telewehab/utils/user_session.dart'; // Import your UserSession model

class DashboardController extends GetxController {
  // Existing controllers
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

  // Existing reactive variables
  RxString nationalCode = ''.obs;
  RxString fullName = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;
  RxString weight = ''.obs;
  RxString height = ''.obs;
  RxString reason = ''.obs;
  RxString education = ''.obs;
  RxString relationshipStatus = ''.obs;
  RxString childrenCount = ''.obs;
  RxString doctorName = ''.obs;
  RxString therapistName = ''.obs;
  RxString appointmentDate = ''.obs;
  RxString helperTool = ''.obs;
  RxString address = ''.obs;

  // Existing patient lists
  var patients = <Patient>[].obs;
  var patient = Rxn<Patient>(); // Rxn means nullable reactive variable
  var isLoading = false.obs;
  var error = ''.obs;

  // NEW: VAS Score functionality
  final RxList<PatientWithVAS> patientsWithVAS = <PatientWithVAS>[].obs;
  final RxString errorMessage = ''.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    
    // Load VAS scores for the operator
    loadPatientsWithVAS();
    
    // Existing functionality
    fetchPatients();

    // Setup listeners
    nationalCodeController.addListener(() {
      nationalCode.value = nationalCodeController.text;
    });
    
    FullNameController.addListener(() {
      fullName.value = FullNameController.text;
    });
    
    GenderController.addListener(() {
      gender.value = GenderController.text;
    });
    
    BirthDateController.addListener(() {
      birthDate.value = BirthDateController.text;
    });
    
    WeightController.addListener(() {
      weight.value = WeightController.text;
    });
    
    HeightController.addListener(() {
      height.value = HeightController.text;
    });
    
    ReasonController.addListener(() {
      reason.value = ReasonController.text;
    });
    
    EducationController.addListener(() {
      education.value = EducationController.text;
    });
    
    MarriageController.addListener(() {
      relationshipStatus.value = MarriageController.text;
    });
    
    ChildrenCountController.addListener(() {
      childrenCount.value = ChildrenCountController.text;
    });
    
    DoctorNameController.addListener(() {
      doctorName.value = DoctorNameController.text;
    });
    
    TherapistNameController.addListener(() {
      therapistName.value = TherapistNameController.text;
    });
    
    AppointmentDateController.addListener(() {
      appointmentDate.value = AppointmentDateController.text;
    });
    
    HelperToolController.addListener(() {
      helperTool.value = HelperToolController.text;
    });
    
    AddressController.addListener(() {
      address.value = AddressController.text;
    });
  }

  // Existing methods
  Future<void> fetchPatients() async {
    try {
      isLoading(true);
      final response = await ApiService.getPatients(); // Returns List

      patients.value = List<Patient>.from(
          response.map((json) => Patient.fromJson(json as Map<String, dynamic>)));
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
      final result = await _apiService.searchPatient(nationalCode.trim());
      patient.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: Load patients with VAS scores for the logged-in operator
  Future<void> loadPatientsWithVAS() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get operator national code from UserSession
      final operatorNationalCode = UserSession.currentUser?.nationalCode;

      if (operatorNationalCode == null || operatorNationalCode.isEmpty) {
        throw Exception('Operator national code not found in session');
      }

      print('Loading VAS scores for operator: $operatorNationalCode');

      // Fetch patients with VAS scores
      final results = await _apiService.getPatientsWithVASScores(operatorNationalCode);

      patientsWithVAS.value = results;

      // Sort by VAS score (highest first for priority viewing)
      patientsWithVAS.sort((a, b) => b.vasScore.compareTo(a.vasScore));

      print('Loaded ${patientsWithVAS.length} patients with VAS scores');
    } catch (e) {
      errorMessage.value = 'خطا در بارگذاری اطلاعات: $e';
      print('Error loading patients with VAS: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: Refresh all data
  Future<void> refreshData() async {
    await loadPatientsWithVAS();
  }

  // NEW: Filter patients by VAS score range
  List<PatientWithVAS> filterByVASRange(double minScore, double maxScore) {
    return patientsWithVAS
        .where((p) => p.vasScore >= minScore && p.vasScore <= maxScore)
        .toList();
  }

  // NEW: Get critical patients (VAS >= 7)
  List<PatientWithVAS> getCriticalPatients() {
    return patientsWithVAS.where((p) => p.vasScore >= 7).toList();
  }

  // NEW: Get high priority patients (VAS >= 5)
  List<PatientWithVAS> getHighPriorityPatients() {
    return patientsWithVAS.where((p) => p.vasScore >= 5).toList();
  }

  // NEW: Get low risk patients (VAS < 3)
  List<PatientWithVAS> getLowRiskPatients() {
    return patientsWithVAS.where((p) => p.vasScore < 3).toList();
  }

  // NEW: Get medium risk patients (3 <= VAS < 5)
  List<PatientWithVAS> getMediumRiskPatients() {
    return patientsWithVAS.where((p) => p.vasScore >= 3 && p.vasScore < 5).toList();
  }

  @override
  void onClose() {
    // Dispose all controllers
    nationalCodeController.dispose();
    phoneNumberController.dispose();
    FullNameController.dispose();
    GenderController.dispose();
    BirthDateController.dispose();
    WeightController.dispose();
    HeightController.dispose();
    ReasonController.dispose();
    EducationController.dispose();
    MarriageController.dispose();
    ChildrenCountController.dispose();
    DoctorNameController.dispose();
    TherapistNameController.dispose();
    AppointmentDateController.dispose();
    RelationshipController.dispose();
    HelperToolController.dispose();
    AddressController.dispose();
    super.onClose();
  }
}

class AppBarBlurController extends GetxController {
  final scrollOffset = 0.0.obs;

  void updateScroll(double offset) {
    scrollOffset.value = offset;
  }

  /// Blur strength grows from 0 to max 12 when scrolled 0..200 px
  double get blurValue => (scrollOffset.value / 200 * 12).clamp(0.0, 12.0);

  /// Opacity: 1.0 at top, then gradually lower (but not fully transparent)
  double get opacity => (1.0 - (scrollOffset.value / 200)).clamp(0.6, 1.0);
}