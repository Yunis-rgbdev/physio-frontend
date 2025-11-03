import 'package:flutter/material.dart';
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

class LoginController extends GetxController with InputValidationMixin {
  final formKey = GlobalKey<FormState>();

  RxString nationalCode = ''.obs;
  RxString password = ''.obs;
  TextEditingController nationalCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

   @override
  void onInit() {
    super.onInit();
    // Sync changes both ways:
    nationalCodeController.addListener(() {
      nationalCode.value = nationalCodeController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
  }

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
}
