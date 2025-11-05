import 'package:flutter/material.dart';
import 'package:telewehab/utils/api_service.dart';
import 'package:get/get.dart';

mixin InputValidationMixin {
  String? validateNationalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'کدملی الزامی است';
    }
    if (value.length != 10) {
      return 'کدملی باید ۱۰ رقم باشد';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'کدملی فقط باید شامل عدد باشد';
    }
    return null;
  }
}

class SignupController extends GetxController with InputValidationMixin {
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  TextEditingController nationalCodeController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  RxString nationalCode = ''.obs;
  RxString fullName = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nationalCodeController.addListener(
      () {
        nationalCode.value = nationalCodeController.text;
      }
    );
    fullNameController.addListener(
      () {
        fullName.value = fullNameController.text;
      }
    );
    phoneNumberController.addListener(
      () {
        phoneNumber.value = phoneNumberController.text;
      }
    );
    birthDateController.addListener(
      () {
        birthDate.value = birthDateController.text;
      }
    );
    genderController.addListener(
      () {
        gender.value = genderController.text;
      }
    );

    bool validateForm() => formKey.currentState?.validate() ?? false;

    void submit() {
      if (validateForm()) {
        Get.snackbar('موفق', 'ورود موفقیت‌آمیز بود');
      } else {
        Get.snackbar('خطا', 'کدملی معتبر نیست',
          backgroundColor: Colors.red[100], colorText: Colors.black);
      }
    }

    @override
    void onClose() {
      nationalCodeController.dispose();
      super.onClose();
    }

    void sendRegister() async {
    try {
      isLoading.value = true;
      // final responseData = await ApiService.login(
      // nationalCode.value.trim(),
      // password.value.trim(),
      // );
      Get.offAllNamed('/login');
      } catch (e) {
        Get.snackbar('registeration Failed', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }
  }
}